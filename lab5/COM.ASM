//	AUXR EQU 8EH
//	ORG 0000H
//	LJMP MAIN
//	ORG 0023H
//	LJMP INT_ISR
//	ORG 0100H
//
//MAIN:
//	ANL TMOD, #20H  ;定时器1为方式2
//	MOV TH1,#0FDH
//	MOV TL1,#0FDH
//	SETB TR1	;定时器1开始计时
//
//	MOV AUXR,#00H    ;定时器1作为波特率发生器
//	MOV SCON,#11010000B   ;串口设置为工作方式3,允许接收，将TB8设为偶校验位'0'
//	MOV PCON,#10000000B	  ;波特率加倍
//
//	SETB ES
//	SETB EA		;串行口中断允许	
//	SJMP $
//
//INT_ISR:
//	CLR EA	   ;关中断
//	CLR RI	   ;清除串行口1中断标志
//	PUSH DPL   ;保护现场
//	PUSH DPH
//	PUSH ACC
//	MOV A,SBUF	;收到小写字母
//	SUBB A,#20H	;变成大写字母
//	MOV SBUF,A	;返回大写字母
//CHECK:
//	JNB TI,CHECK   ;等待发送结束
//	CLR TI		   ;发完恢复现场
//	POP ACC
//	POP DPH
//	POP DPL
//	SETB EA		   ;开中断
//	RETI
//	END

//ORG 0000H
//	LJMP MAIN
//	ORG 0100H
//MAIN:
//	MOV 8EH, #00H    ;1为定时器
//	MOV TMOD, #20H   ;T以方式2工作
//	MOV TH1, #0F4H   ;初始值N=244
//	MOV TL1, #0F4H	;初始值N=244
//	MOV SCON, #40H   ;串口设置为工作方式1 
//	MOV PCON, #080H  ;波特率加倍，SMOD=1
//	SETB TR1	       ;定时器T1开始工作
//SEND:
//	MOV SBUF, #05AH  ;发送N的ASCII码
//WAIT:
//	JNB TI, WAIT     ;查询TI为0，则未发完，继续等待，为1则发送完
//	CLR TI		       ;手动清零TI，准备再次发送下一个内容
//	SJMP SEND	       ;循环发送
//END
