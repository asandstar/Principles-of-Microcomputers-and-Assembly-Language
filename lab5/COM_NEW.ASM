	AUXR EQU 8EH
	ORG 0000H
	LJMP MAIN
	ORG 0023H
	LJMP INT_ISR
	ORG 0100H

MAIN:
	MOV TMOD, #20H  ;定时器1为方式2
	MOV TH1,#0E8H	;波特率2400
	MOV TL1,#0E8H
	SETB TR1	;定时器1开始计时

	MOV AUXR,#00H    ;定时器1作为波特率发生器
	MOV SCON,#11010000B   ;串口设置为工作方式3,允许接收，将TB8设为偶校验位'0'
	MOV PCON,#10000000B	  ;波特率加倍

	SETB ES
	SETB EA		;串行口中断允许	
	SJMP $

INT_ISR:
	CLR EA	   ;关中断
	CLR RI	   ;清除串行口1中断标志
	PUSH DPL   ;保护现场
	PUSH DPH
	PUSH ACC
	MOV A,SBUF	;收到小写字母
	MOV C,P	;获取校验位
	MOV TB8,C
	CLR C
	SUBB A,#20H	;变成大写字母
	MOV SBUF,A	;返回大写字母
CHECK:
	JNB TI,CHECK   ;等待发送结束
	CLR TI		   ;发完恢复现场
	POP ACC
	POP DPH
	POP DPL
	SETB EA		   ;开中断
	RETI
	END
