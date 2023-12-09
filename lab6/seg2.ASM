;实现了功能
/*2.初态显示小数点，有键（外部中断方式）参与，数码管静态显示：8个数码管根据按键同时显示键值*/
	ORG 0000H
	LJMP MAIN
	ORG 0003H  				;外部中断0入口地址
	LJMP INT0_ISR
	
	ORG 0100H  
MAIN:
	MOV 93H,#00H
	MOV 94H,#0FFH			;P0设置为推挽模式
	MOV 91H,#00H
	MOV 92H,#0FFH			;P1设置为推挽模式
	MOV 95H,#00H
	MOV 96H,#0FFH			;P2设置为推挽模式
	MOV SP,#50H				;设置堆栈
	
	SETB IT0				;外部中断0下降沿触发
	SETB PX0				;中断0优先
	SETB EX0				;允许外部中断0
	SETB EA					;允许总中断

	MOV P2,#00H				;选通所有8管
	MOV P1,#0F0H			;行开放

INT0_ISR:
	CLR EA					;关中断
	LCALL DELAY10MS			;按键消抖
	MOV A,#11111110B		;行扫描
	MOV R3,#04H

KEYSCAN:
	MOV P0,#80H
	MOV P1,A 				;行扫描赋值
	MOV B,P1 				;存下当前行扫描值
	CJNE A,B,FIND   		;如果不等则证明有键按下
	RL A		    		;相等则没有按键按下，继续行扫描
	DJNZ R3,KEYSCAN			;4行都扫描
	SJMP EXIT				;扫描结束，没有键按下，退出中断

FIND:	
	MOV DPTR,#KEY  			;键值查表准备
	MOV R0,#0FFH   			;为段显示准备

KEYSELECT:
	INC R0	   				;R0初值0，对应KEY0
	CJNE R0,#16,SEGSELECT	;到KEY15都转移到段选通
	SJMP EXIT

SEGSELECT:	
	MOV A,R0   				;用A保存找到的键值的相对数
	MOVC A,@A+DPTR			;依据相对数寻找实际键值
	CJNE A,B,KEYSELECT		;如果不等则证明有键按下，找键相对数
	MOV DPTR,#SEG			;段选通查表准备
	MOV A,R0				;用A保存找到的键值的相对数
	MOVC A,@A+DPTR	 		;依据相对数寻找段选通值
	MOV P0,A		 		;把键值对应的选通值送给P0
	SJMP EXIT

EXIT:
	CLR IE0					;清除外部中断INT0的请求标志位
	SETB EA					;允许中断
	MOV P1,#0F0H			;行开放
	RETI					;中断返回

//DELAY20MS:					;消除按键抖动
//	PUSH 30H
//	PUSH 31H
//	MOV 30H,#173
//	MOV 31H,#27
//NEXT:
//	DJNZ 31H,NEXT
//	DJNZ 30H,NEXT
//	POP 31H
//	POP 30H
//	RET

DELAY10MS:          ;@11.0592MHz  
	NOP  
	NOP  
	NOP  
	PUSH 30H  
	PUSH 31H  
	MOV 30H,#87  
	MOV 31H,#10  
NEXT:  
	DJNZ 31H,NEXT  
	DJNZ 30H,NEXT  
	POP 31H  
	POP 30H  
	RET  

	ORG 1000H
KEY:					;键编码
//	DB 0EEH,0DEH,0BEH,7EH,0EDH,0DDH,0BDH,7DH
//	DB 0EBH,0DBH,0BBH,7BH,0E7H,0D7H,0B7H,77H
	DB 07EH,0BEH,0DEH,0EEH	;3,2,1,0
	DB 07DH,0BDH,0DDH,0EDH	;7,6,5,4
	DB 07BH,0BBH,0DBH,0EBH	;B,A,9,8
	DB 077H,0B7H,0D7H,0E7H	;F,E,D,C

	ORG 1100H
SEG:				;段码
	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
	DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
	END




//	ORG 0000H
//	LJMP MAIN
//	ORG 0003H  			;外部中断0中断服务程序的入口地址
//	LJMP INT01
//	
//	ORG 0100H  
//MAIN:
//	MOV 93H,#00H
//	MOV 94H,#0FFH			;P0设置为推挽模式
//	MOV 91H,#00H
//	MOV 92H,#0FFH			;P1设置为推挽模式
//	MOV 95H,#00H
//	MOV 96H,#0FFH			;P2设置为推挽模式
//	MOV SP,#50H				;堆栈
//	
//	SETB IT0				;外部中断0下降沿触发
//	SETB PX0
//	SETB EX0
//	SETB EA				;允许外部中断0
//
//	MOV P2,#00H			;同时选通8个数码管
//	MOV P1,#0F0H			;行开放（P0.0-P0.3置为0）
//
//INT01:
//	CLR EA					;关闭中断
//	LCALL DELAY20MS		;延时20毫秒以消除按键抖动
//	MOV A,#11111110B		;开始逐行扫描
//	MOV R3,#04H
//
//LOOP1:
//	MOV P0,#80H
//	MOV P1,A
//	MOV 30H,P1
//	CJNE A,30H,FINDKEY
//	RL A
//	DJNZ R3,LOOP1
//	SJMP RETURN
//
//FINDKEY:	
//	MOV DPTR,#KEY_CODE
//	MOV R0,#0FFH
//
//LOOP2:
//	INC R0
//	CJNE R0,#16,LOOP3	
//;不相等则跳转至LOOP3遍历键码表
//	SJMP RETURN
//
//LOOP3:
//	
//	MOV A,R0
//	MOVC A,@A+DPTR
//	CJNE A,30H,LOOP2
//	MOV DPTR,#CODE_TABLE
//	MOV A,R0
//	MOVC A,@A+DPTR
//	MOV P0,A
//	SJMP RETURN
//
//RETURN:
//	CLR IE0
//	SETB EA				;允许中断
//	MOV P1,#0F0H			;行开放（P0.0-P0.3置为0）
//	RETI					;中断返回
//
//DELAY20MS:					;消除按键抖动的延时子程序
//	PUSH 30H
//	PUSH 31H
//	MOV 30H,#173
//	MOV 31H,#27
//NEXT:
//	DJNZ 31H,NEXT
//	DJNZ 30H,NEXT
//	POP 31H
//	POP 30H
//	RET
//
//	ORG 1000H
//KEY_CODE:					;键编码
////	DB 0EEH,0DEH,0BEH,7EH,0EDH,0DDH,0BDH,7DH
////	DB 0EBH,0DBH,0BBH,7BH,0E7H,0D7H,0B7H,77H
//	DB 07EH,0BEH,0DEH,0EEH	;3,2,1,0
//	DB 07DH,0BDH,0DDH,0EDH	;7,6,5,4
//	DB 07BH,0BBH,0DBH,0EBH	;B,A,9,8
//	DB 077H,0B7H,0D7H,0E7H	;F,E,D,C
//
//	ORG 1100H
//CODE_TABLE:				;段码
//	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
//	DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
//	END
//
//


