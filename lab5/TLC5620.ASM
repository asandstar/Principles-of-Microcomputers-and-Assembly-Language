	SCLA EQU P1.0
	SDAA EQU P1.1
	LOAD EQU P1.2
	LDAC EQU P1.3
	ORG 0000H
	LJMP MAIN
	ORG 0100H
MAIN:
	MOV SP,#60H
	SETB SCLA	;ʱ�Ӷ�Ĭ�ϸߵ�ƽ
	SETB SDAA	;�����ref=2.5V�ο���ѹ
	SETB LOAD	;�������������ݿڵĵ�ƽ
	SETB LDAC	;���߿���DAC��ƽ
	MOV R1,#11100000B ;A1A0=11�����λDACD��RNG=1
	MOV R2, #0AH
	LCALL DAC5620
	SJMP MAIN
	
	SJMP $

DAC5620:	
	MOV	A,R1		;R1Ϊ�����ֽ�
	CLR	SCLA		;����ʱ�Ӷ�
	MOV	R7,#03H		;����ѭ��������3bist
	LCALL SENDBYTE	;���������ӳ��򣬷��Ϳ�����
	MOV	A,R2		;R2Ϊ��ת������
	CLR	SCLA		;����ʱ�Ӷ�
	MOV	R7,#08H		;����ѭ��������8bit
	LCALL SENDBYTE	;���������ӳ��򣬷�����������
	CLR	LOAD		;��������
	SETB LOAD
	CLR	LDAC		;����DAC���
	SETB LDAC
	RET

SENDBYTE:	
	SETB SCLA		 ;��λʱ�Ӷ�
	RLC	A		 ;ѭ����λ1λ����
	MOV	SDAA,C		 ;��������Ĵ���
	CLR	SCLA		 ;����ʱ���½��أ���������
	DJNZ R7,SENDBYTE	 ;ѭ��
	RET
	
	END
