	ORG 0000H
	LJMP MAIN
//	ORG 0003H
//	LJMP INT_KEY1
//	ORG 0013H
//	LJMP INT_KEY2

	ORG 0100H
MAIN:
	MOV TMOD,#11H ;T1-mode1, T0-mode1
	SETB P1.0
	MOV R0,#0F1H   ;R0,R1 保存高电平维持时间
	MOV R1,#99H
	MOV R2,#0C6H   ;R2,R3 保存低电平维持时间
	MOV R3,#66H
	MOV TH0,R0		;T0赋初值
	MOV TL0,R1
	MOV TH1,R2		;T1赋初值
	MOV TL1,R3
	SETB EA			;CPU 开放中断
	SETB IT0		;边沿触发
	SETB IT1
	SETB EX0		;允许外部中断
	SETB EX1
SWITCH:
	JB P1.7,DUTY20
	JNB P1.7,DUTY40
TIME0:
	MOV TH0,R0		 ;赋pwm波的高电平初值
	MOV TL0,R1	
	SETB TR0		 ;开启定时器0
CHECK:
	JBC TF0,OVERFLOW0  ;检查定时是否满高电平时间
	LJMP CHECK
OVERFLOW0:
	CLR P1.0			;开始低电平时间
	CLR TR0				;关闭定时器0
TIME1:
	MOV TH1,R2		 ;赋pwm波的低电平初值
	MOV TL1,R3
	SETB TR1		 ;开启定时器1
CHECK1:
	JBC TF1,OVERFLOW1  ;检查定时是否满低电平时间
	LJMP CHECK1
OVERFLOW1:
	SETB P1.0		  ;开始高电平时间
	CLR TR1			  ;关闭定时器1
	LJMP SWITCH

DUTY40:
	MOV R0,#0E3H   ;R0,R1 保存高电平维持时间
	MOV R1,#33H
	MOV R2,#0D4H   ;R2,R3 保存低电平维持时间
	MOV R3,#0CCH 
	LJMP TIME0
DUTY20:
	MOV R0,#0F1H   ;R0,R1 保存高电平维持时间
	MOV R1,#99H
	MOV R2,#0C6H   ;R2,R3 保存低电平维持时间
	MOV R3,#66H
	LJMP TIME0

//
//INT_KEY1:
//	ACALL DELAY50MS	
//	ACALL ADD20			;进入中断调用增加占空比程序
//	RETI
//
//INT_KEY2:
//	ACALL DELAY50MS
//	ACALL DEC20			;进入中断调用减少占空比程序
//	RETI
//
//ADD20:	
//	CLR C
//	MOV A,R0			 ;增加高电平时间
//	SUBB A,#0EH
//	MOV R0,A
//	CLR C
//   	MOV A,R1
//	SUBB A,#67H
//	MOV R1,A
//	CLR C
//	MOV A,R2
//	ADD A,#0EH			  ;减小高电平时间
//	MOV R2,A
//	CLR C
//	MOV A,R3
//	ADD A,#67H
//	MOV R3,A
//	RET
//
//DEC20:	
//	CLR C
//	MOV A,R0
//	ADD A,#0EH			   ;减小高电平时间
//	MOV R0,A
//	CLR C
//   	MOV A,R1
//	ADD A,#67H
//	MOV R1,A
//	CLR C
//	MOV A,R2
//	SUBB A,#0EH			   ;增加高电平时间
//	MOV R2,A
//	CLR C
//	MOV A,R3
//	SUBB A,#67H
//	MOV R3,A
//	RET
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


	END
