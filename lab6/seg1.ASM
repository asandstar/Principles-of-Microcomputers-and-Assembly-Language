//�θ�ѡͨ��λ��ѡͨ
	AUXR EQU 8EH
	ORG 0000H
	LJMP MAIN
	ORG 000BH
	LJMP T0_ISR

   	ORG 0200H
MAIN:
	MOV 93H,#00H  ;p0����ģʽ,λѡͨ
	MOV 94H,#0FFH
	MOV 91H,#00H  ;P1����ģʽ����ѡͨ
	MOV 92H,#0FFH
	MOV 95H,#00H  ;P2����ģʽ
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
	MOV R1,#40H			;λѡͨ

TIMER0_INIT:			
	ANL	AUXR,#7FH		;��ʱ��ʱ��12Tģʽ
	ANL	TMOD,#0F0H		;���ö�ʱ��ģʽ
//	;500΢��@11.0592MHz
//	MOV	TL0,#033H		;���ö�ʱ��ʼֵ
//	MOV	TH0,#0FEH		;���ö�ʱ��ʼֵ
//	;2����@11.0592MHz
//	MOV	TL0,#0CDH		;���ö�ʱ��ʼֵ
//	MOV	TH0,#0F8H		;���ö�ʱ��ʼֵ
	;1����@11.0592MHz
	MOV	TL0,#066H		;���ö�ʱ��ʼֵ
	MOV	TH0,#0FCH		;���ö�ʱ��ʼֵ

	SETB ET0	  ;��ʱ���ж�
	SETB EA
	SETB TR0	  ;��ʱ��0��ʼ��ʱ
	CLR TF0

	SJMP $
	
		
	ORG 0400H
T0_ISR:
	CJNE R1,#48H,SEG	;λѡͨ��ֵ
	MOV R1,#40H			;����λѡͨ
	SJMP SEG		
	RETI
SEG:
	MOV A,R2
	RL A			  ;��һλ��
	MOV P0,A
	MOV R2,A

	MOV A,@R1		 ;��ѡͨ
	MOV P1,A
	INC R1		
	RETI
	END
