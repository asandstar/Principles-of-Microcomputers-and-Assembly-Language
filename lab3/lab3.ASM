	COUNT EQU 60H
	ORG 0000H
	LJMP MAIN
	ORG 0100H
MAIN:
	MOV TMOD, #15H    ; T0 - Mode 1, T1 - Mode 0
    MOV TH0, #00H     ; T0计数
    MOV TL0, #00H
    MOV TH1, #4BH       ;T1定时,50ms 
    MOV TL1, #0FDH
    MOV COUNT, #20     ; 计数器初始化为 0
    SETB TR0          ; 启动 T0 定时器
    SETB TR1          ; 启动 T1 计数器
CON:
	JNB TF1, CON 	;定时50ms后，溢出标志位=1往下执行，=0则继续计时
	CLR TF1			; 溢出标志清0
    MOV TH1, # 4BH       ; T1计时，手动重载 
    MOV TL1, # 0FDH
	DEC COUNT	   ;计数次数减少
	MOV A, COUNT   ;把数值放进A用于判断
	JNZ CON	   ;计数次数未达20次，继续计时
	CLR TR0	   ;计数时间达到1s，停止计数
	MOV R2,TH0 ;存高8位
	MOV R3,TL0 ;存低8位
	SJMP $
	END


//	COUNT EQU 60H
//	RESULT EQU 61H
//	ORG 0000H
//	LJMP MAIN
//
//	ORG 0100H
//MAIN:
//	MOV TMOD, #15H    ; T0 - Mode 1, T1 - Mode 0
//    MOV TH0, #00H     ; T0计数
//    MOV TL0, #00H
//    MOV TH1, #4BH       ; T1计时 
//    MOV TL1, #0FDH
//    MOV COUNT, #20     ; 计数器初始化为 0
//    //MOV RESULT, #0    ; 存储结果的位置初始化为 0
//    SETB TR0          ; 启动 T0 定时器
//    SETB TR1          ; 启动 T1 计数器
//	MOV R0,#30H;存高8位
//	MOV R1,#31H;存低8位
//CON:
//	JNB TF1, CON 	;定时50ms后，溢出标志位=1往下执行，=0则继续计时
//	CLR TF1			; 溢出标志清0
//    MOV TH1, #4BH       ; T1计时 
//    MOV TL1, #0FDH 
//	DEC COUNT
//	MOV A, COUNT
//	JNZ CON
//	CLR TR0
//	MOV A,R1
//	JNZ ADDADDRESS
//	JZ STORE
//ADDADDRESS:
//	MOV A,R0
//	ADD A,#02H ;往后移动两个地址
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;往后移动两个地址
//	MOV R1,A
//	DEC RESULT;可以存的结果数减少	
//
//STORE:	MOV @R0,TH0
//		MOV @R1,TL0
////	MOV R2,TH0
////	MOV R3,TL0
//	SJMP $
//	END




//	MOV A,@R1
//	JZ STORE
//STORE:
//	MOV @R0,TH0;R0指向的地址里存高8位
//	MOV @R1,TL0;R1指向的地址里存低8位
//	MOV A,R0
//	ADD A,#02H ;往后移动两个地址
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;往后移动两个地址
//	MOV R1,A
//	DEC RESULT;可以存的结果数减少
//	MOV A,RESULT
//	JNZ CON ;结果没到10个，继续存





////测试 存储结果 是否存入理想地址的程序（成功）
//	COUNT EQU 60H
//	ORG 0000H
//	LJMP MAIN
//
//	ORG 0100H
//MAIN:
//	MOV R0,#30H;存高8位
//	MOV R1,#31H;存低8位
//	
//	
//	MOV 70H,#01H
//	MOV 71H,#02H
//	MOV COUNT, #20;16+4 14H
//
//LOOP:
//	MOV @R0,70H;R0指向的地址里存高8位
//	MOV @R1,71H;R1指向的地址里存低8位
//	MOV A,R0
//	ADD A,#02H ;往后移动两个地址
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;往后移动两个地址
//	MOV R1,A
//	DEC COUNT
//	MOV A,COUNT
//	JNZ LOOP
//
//	SJMP $
//	END





////用按键或拨盘开关控制产生2种音频信号使蜂鸣器发声。
//	ORG 0000H
//	LJMP MAIN
//	ORG 0003H
//	LJMP INTEX0  ;外部中断0
//	ORG 000BH
//	LJMP INTT0 ;定时器中断0
//	ORG 0013H
//	LJMP INTEX1  ;外部中断1
//
//	ORG 0100H
//MAIN:
//	 MOV TMOD, #00H ;T0、T1,方式0
//	 CLR IT0 ;INT0下降沿触发
//	 CLR IT1 ;INT1下降沿触发
//	 SETB EX0 ;外部中断0允许
//	 SETB EX1  ;外部中断1允许
//	 SETB EA   ;允许单片机总中断
//	 SETB PX1 ;设置外部中断1为中断优先级
//	 SETB ET0  ;T0中断允许
//	 SETB TR0 ;T0计数启动
//
//LOOP:
//	SJMP LOOP
//
//	ORG 0200H
//INTEX0:
//	ACALL DELAY50MS	;软件消抖
//	JB P3.2,RE1	 ;KEY1按下，蜂鸣器播放一种频率声音
//	MOV TH0,#0F9H
//	MOV TL0,#01EH
//RE1:
//	RETI
//INTEX1:
//	 ACALL DELAY50MS ;软件消抖
//	 JB P3.3,RE2  ;KEY2按下，蜂鸣器播放另一种频率声音
//	 MOV TH0,#0FBH
//	 MOV TL0,#0E8H
//RE2:
//	RETI
//
//INTT0:
//	CPL P1.0   ;产生方波
//	RETI
//
//
//DELAY50MS:			;@11.0592MHz
//	NOP
//	NOP
//	NOP
//	PUSH	30H
//	PUSH	31H
//	PUSH	32H
//	MOV		30H,#2
//	MOV		31H,#175
//	MOV		32H,#72
//NEXT50:
//	DJNZ	32H,NEXT50
//	DJNZ	31H,NEXT50
//	DJNZ	30H,NEXT50
//	POP		32H
//	POP		31H
//	POP		30H
//	RET
//
//	SJMP $
//	END
//
// 
////开关是查询	  不要放在p3.2,p3.3
//按键是中断	  p3.2,p3.3
//带clear的判断指令学会使用JVC