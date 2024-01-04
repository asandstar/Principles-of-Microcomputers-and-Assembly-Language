//		DL EQU P1.0         ;�����������źţ�ѡͨ��
//		DH EQU P1.1         ;�����������źţ����ݣ�
//		CLK EQU P1.2        ;��λʱ���ź�SCLK
//		STR EQU P1.3        ;����ʱ���ź�RCK
//		OE EQU P1.4         ;���ʹ���ź�
//		ROW_H EQU 41H   	;���źŸ�8λ��ѡͨ��
//		ROW_L EQU 42H   	;���źŵ�8λ��ѡͨ��
//		COL_H EQU 43H     	;���źŸ�8λ�����ݣ�
//		COL_L EQU 44H     	;���źŵ�8λ�����ݣ�
//		ORG 0000H
//		LJMP MAIN
//		ORG 0100H		
//
//		ORG 0200H
//MAIN:
//		MOV R1, #01H 			;�п�ʼɨ���λ��
//		MOV R2, #01H 			;�п�ʼɨ���λ��
//		MOV R3, #10H 			;ѭ��������16 ��
//LOOP: 
//		MOV DPTR, #ROWTAB 		;Ѱ���п�ʼɨ����ź�
//		MOV A, R1
//		MOVC A, @A+DPTR 		;���
//		MOV ROW_H, A 			;�洢�еĸ��ֽ�
//		DEC R1 					;R1��1ָ��ɨ����еĵ��ֽ�
//		MOV A, R1 
//		MOVC A,@A+DPTR 			;���
//		MOV ROW_L, A 			;�洢�еĵ��ֽ�
//		INC R1
//		INC R1
//		INC R1 					;ָ����һ�����źŵĸ��ֽ�
//		MOV DPTR, #COLTAB 		;Ѱ���п�ʼɨ����ź�
//		MOV A, R2
//		MOVC A, @A+DPTR 		;���
//		MOV COL_H, A 			;�洢���źŵĸ��ֽ�
//		DEC R2 					;R2��һָ��ɨ����еĵ��ֽ�
//		MOV A, R2
//		MOVC A, @A+DPTR 		;���
//		MOV COL_L, A 			;�洢�еĵ��ֽ�
//		INC R2
//		INC R2
//		INC R2 					;ָ����һ�����źŵĸ��ֽ�
//		LCALL LOCK 				;�����������ݵ��ӳ���
//		LCALL DELAY1MS 			;��ʱ,��ͨ��������Ҫһ��ʱ�䣬����ɨ�����
//		DJNZ R3, LOOP 			;�ж��Ƿ���ɨ����
//		LJMP MAIN 				;16 ��ɨ����ϣ������������ѭ��
//LOCK: 							;���������ӳ���
//		CLR OE 					;�������
//		CLR STR					;�ȴ����������ݼĴ���
//		MOV R4, ROW_H 			;R4�洢�и�λ
//		MOV R5, COL_H 			;R5�洢�и�λ
//		MOV R6, #8 				;8��ѭ��
//LOCKH: 
//		CLR CLK 				;��λ�Ĵ���׼��
//		MOV A, R4
//		RRC A 					;�Ƴ����λ
//		MOV R4, A
//		MOV DL, C 				;P1.0������
//		MOV A, R5
//		RRC A
//		MOV R5, A
//		MOV DH, C 				;P1.1������
//		SETB CLK 				;���и�λ���ݽ�����λ�Ĵ���
//		NOP 					;�ȴ�����ʱ�����ڣ���֤������ȷ����������
//		DJNZ R6, LOCKH 			;�ж�8λ����û��
//		
//		MOV R4, ROW_L 			;R4 �洢�е�λ
//		MOV R5, COL_L 			;R5 �洢�е�λ
//		MOV R6, #8
//LOCKL:
//		CLR CLK
//		MOV A, R4
//		RRC A
//		MOV R4, A
//		MOV DL, C
//		MOV A, R5
//		RRC A
//		MOV R5, A
//		MOV DH, C
//		SETB CLK
//		NOP
//		DJNZ R6, LOCKL
//		SETB STR 				;�������ݼĴ���
//		RET
//DELAY1MS:			;@11.0592MHz
//		PUSH 30H
//		PUSH 31H
//		MOV 30H,#9
//		MOV 31H,#150
//NEXT:
//		DJNZ 31H,NEXT
//		DJNZ 30H,NEXT
//		POP 31H
//		POP 30H
//		RET
//
//
//		END

	HL EQU 30H ;�� ��λ
	HH EQU 31H ;�� ��λ
	LL EQU 32H ;�� ��λ
	LH EQU 33H ;�� ��λ
	
	DL EQU P1.0	;������
	DH EQU P1.1	;������
	CLK EQU P1.2 ;��λ�Ĵ���ʱ��	SRCLK
	STR EQU P1.3 ;������ʱ��		RCLK
	OE EQU P1.4 ;���ʹ��

	ORG 0000H
	LJMP MAIN
	ORG 0100H

MAIN:
	 MOV DPTR,#WORDTAB ;��ģ����ַ
	 MOV R1,#00H ;��ַƫ��
	 MOV HL,#01H ;��һ��  0000 0001B
	 MOV HH,#00H ;��ɨ
LOOP:
	MOV A,R1 ;��ַƫ�Ƴ�ֵ
	MOVC A,@A+DPTR ;ȡ��ģ
	MOV LL,A;���еͰ�λ
	INC R1;׼�����߰�λ

	MOV A,R1;��ַƫ�Ƴ�ֵ
	MOVC A,@A+DPTR ;ȡ��ģ
	MOV LH,A;���и߰�λ

	LCALL HC595
	LCALL DELAY ;��ʱ
	CLR C

	MOV A,HL;�еͰ�λ
	RLC A ;���Ƶ���һ�У���0000 0010B��0000 0100B
	MOV HL,A;�����еͰ�λ

	MOV A,HH;�и߰�λ
	RLC A ;���Ƶ���һ��
	MOV HH,A;�����и߰�λ

	INC R1
	CJNE R1,#20H,LOOP
	LJMP MAIN


HC595:
	CLR OE ;�͵�ƽ��Ч
	CLR STR
	MOV R2, #08H  ;��SHIFT1�ƶ���λ
	MOV R3,LH ;�и�8λ
	MOV R4,HH ;�и�8λ
SHIFT1:
	CLR CLK
	MOV A,R3 ;����λ��
	RLC A	 ;���Ƶ���һ��
	MOV R3,A 
	MOV DH,C ;������

	MOV A,R4 ;����λ��
	RLC A	 ;���Ƶ���һ��
	MOV R4,A
	MOV DL,C

	SETB CLK ;�������������ݽ��Ĵ���
	DJNZ R2,SHIFT1 ;��Ϊ0��������λ
	MOV R2,#08H ;Ϊ0�����¸�ֵ����SHIFT2�ƶ���λ
	MOV R3,LL ;�е�8λ
	MOV R4,HL ;�е�8λ
SHIFT2:
	CLR CLK
	MOV A,R3 ;����λ��
	RLC A	 ;���Ƶ���һ��
	MOV R3,A 
	MOV DH,C ;������

	MOV A,R4 ;����λ��
	RLC A	 ;���Ƶ���һ��
	MOV R4,A
	MOV DL,C

	SETB CLK ;�������������ݽ��Ĵ���
	DJNZ R2,SHIFT2 ;��Ϊ0��������λ
	SETB STR ;�Ĵ�����������������
	RET

DELAY:
	MOV R7,#50
DELAY1:
	MOV R6,#10
DELAY2:
	DJNZ R6, DELAY2
	DJNZ R7, DELAY1
	RET
WORDTAB:

DB 0DFH,0FDH,0DFH,0FDH,000H,080H,0DFH,0FDH,0FFH,0FBH,0EFH,0FBH,0EFH,0FBH,0DFH,0FDH;
DB 0DFH,0FDH,0BFH,0FEH,07FH,0FFH,0BFH,0FEH,0DFH,0FDH,0EFH,0FBH,0F3H,0E7H,0FCH,09FH;"��",0
	END