//�����źŷ�����������ͬƵ�η�����Ƶ�ʣ�����ͨ��RAM����ʾ10�������
	COUNT EQU 60H
	RESULT EQU 61H
	ORG 0000H
	LJMP MAIN

	ORG 0100H
MAIN:
	MOV TMOD,#05H ; T0 - Mode 1, T1 - Mode 0
	MOV TH0,#00H  ;T0����,��0��ʼ
	MOV TL0,#00H  ;
	MOV TH1,#4BH  ;T1��ʱ,50ms
	MOV TL1,#0FDH
	MOV COUNT, #20 ;��ʱ1s
	//MOV RESULT, #9 ;�����Ѿ�����1��
	SETB TR0  ;T0��������������źŷ�����
	SETB TR1  ;T1��ʱ����
	SETB P1.0
	MOV R0,#30H;���8λ
	MOV R1,#31H;���8λ
CON:
	JNB TF1, CON ;��ʱ50ms�������־λ=1����ִ�У�=0�������ʱ
	CLR TF1;���T1�������־λ
	DEC R2;������������
	MOV A,COUNT;����ֵ�Ž�A�����ж�
	JNZ CON;��������δ��20�Σ�������ʱ
	CLR TR0;����ʱ��ﵽ1s��ֹͣ����
	MOV @R0,TH0;R0ָ��ĵ�ַ����8λ
	MOV @R1,TL0;R1ָ��ĵ�ַ����8λ

	SJMP $
	END