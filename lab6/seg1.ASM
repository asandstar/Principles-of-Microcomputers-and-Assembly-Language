//段高选通，位低选通
	AUXR EQU 8EH
	ORG 0000H
	LJMP MAIN
	ORG 000BH
	LJMP T0_ISR

   	ORG 0200H
MAIN:
	MOV 93H,#00H  ;p0推挽模式,位选通
	MOV 94H,#0FFH
	MOV 91H,#00H  ;P1推挽模式，段选通
	MOV 92H,#0FFH
	MOV 95H,#00H  ;P2推挽模式
	MOV 96H,#0FFH

P_INIT:
	MOV R2,#01111111B
	MOV 40H,#3FH		;0
	MOV 41H,#06H		;1
	MOV 42H,#5BH		;2
	MOV 43H,#4FH		;3
	MOV 44H,#66H		;4
	MOV 45H,#6DH		;5
	MOV 46H,#7DH		;6
	MOV 47H,#07H		;7
	MOV R1,#40H			;位选通

TIMER0_INIT:			
	ANL	AUXR,#7FH		;定时器时钟12T模式
	ANL	TMOD,#0F0H		;设置定时器模式
//	;500微秒@11.0592MHz
//	MOV	TL0,#033H		;设置定时初始值
//	MOV	TH0,#0FEH		;设置定时初始值
//	;2毫秒@11.0592MHz
//	MOV	TL0,#0CDH		;设置定时初始值
//	MOV	TH0,#0F8H		;设置定时初始值
	;1毫秒@11.0592MHz
	MOV	TL0,#066H		;设置定时初始值
	MOV	TH0,#0FCH		;设置定时初始值

	SETB ET0	  ;定时器中断
	SETB EA
	SETB TR0	  ;定时器0开始计时
	CLR TF0

	SJMP $
	
		
	ORG 0400H
T0_ISR:
	CJNE R1,#48H,SEG	;位选通后赋值
	MOV R1,#40H			;重新位选通
	SJMP SEG		
	RETI
SEG:
	MOV A,R2
	RL A			  ;下一位！
	MOV P0,A
	MOV R2,A

	MOV A,@R1		 ;段选通
	MOV P1,A
	INC R1		
	RETI
	END

