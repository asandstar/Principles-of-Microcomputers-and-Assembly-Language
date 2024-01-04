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
//ROWTAB:
//;��ɨ�� ���д����� ����ʽ
//
//DB 0DFH,0FEH,0DFH,0FEH,0DFH,0FDH,0DFH,0FDH,0D9H,0FBH,00EH,077H,0DFH,0AFH,0DFH,0DFH;
//DB 0DFH,0AFH,00EH,077H,0D1H,0FBH,0DFH,0FDH,0DFH,0FDH,0DFH,0FEH,0DFH,0FEH,0FFH,0FFH;"��",0
//
//
//
////		DB 80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H,00H
////		DB 00H,80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H	//�и���Ч���е���Ч
//COLTAB:		  //���룬˳������
//		DB 0FBH, 0BFH, 0C0H, 007H, 0FBH, 0BFH, 0FBH, 0BFH, 000H, 001H, 0FEH, 0FFH, 0E0H, 00FH, 0EEH, 0EFH
//		DB 0EEH, 0EFH, 0E0H, 00FH, 0EEH, 0EFH, 0EEH, 0EFH, 0E0H, 00FH, 0FBH, 0BFH, 0F7H, 0DFH, 0EFH, 0EFH
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
//		END
//
	DH bit P1.0         ;���������������źţ������б��룩
	DL bit P1.1         ;����������ѡ�ź�
	CLK bit P1.2        ;��λʱ���ź�SCK
	STR bit P1.3        ;����ʱ���ź�RCLK
	OE bit P1.4         ;���ʹ���ź�
	SELECT_H EQU 41H    ;��ѡͨ�źŸ�8λ
	SELECT_L EQU 42H    ;��ѡͨ�źŵ�8λ
	DATA_H EQU 43H      ;�������źŸ�8λ
	DATA_L EQU 44H      ;�������źŵ�8λ
	TIME EQU 45H        ;��¼ÿ֡�ӳ�ʱ��
	ROW_DATA EQU 2000H        ;��ģ���ݱ�
	ROW_SELECT EQU 2200H      ;��ѡ���ݱ�

       ORG 0000H
       LJMP MAIN
       ORG 0100H
MAIN:	
        MOV 46H, #00H            ;����Ѿ�����������
		MOV R3, #00H             ;�������ź�ƫ����
		MOV R4, #00H             ;��ѡͨ�ź�ƫ����
START:	
        MOV TIME, #30            ;ÿ֡��ʾ30��
ROLL:
		MOV R4, #00H
		MOV A, 46H
        MOV R3, A
        MOV R2, #10H             ;����16��
LOAD: 
       MOV DPTR, #ROW_DATA      ;����ģ���ݱ�
		MOV A, R3
		MOVC A, @A+DPTR
		MOV DATA_H, A            ;�����������źŸ�8λ
		INC R3
		MOV A, R3
		MOVC A, @A+DPTR
		MOV DATA_L, A            ;�����������źŵ�8λ
		INC R3
		MOV DPTR, #ROW_SELECT    ;����ѡͨ�źű�
		MOV A, R4
		MOVC A, @A+DPTR
		MOV SELECT_H, A          ;������ѡͨ�źŸ�8λ
		INC R4
		MOV A, R4
		MOVC A, @A+DPTR
		MOV SELECT_L, A          ;������ѡͨ�źŵ�8λ
		INC R4
		ACALL SHIFT
		ACALL DELAY1MS
		DJNZ R2, LOAD            ;ѭ��16��
		DJNZ TIME, ROLL
		MOV A, 46H
		INC A
		INC A
		MOV 46H, A
		CJNE A, #20H, START     ;����16�к��ͷ��ʼ
		LJMP MAIN

SHIFT:	                         ;�����������
		CLR OE                   ;�������
		CLR STR
		MOV R0, DATA_H
		MOV R1, SELECT_H
		MOV R5, #8               ;8λ����8��
SHIFT_H:
		MOV A, R0                ;������ģ���ݸ�8λ
		RLC A                    ;ѭ������1λ
		MOV R0, A
		MOV DH, C                ;��λ����DH��������
		CLR CLK
		MOV A, R1                ;������ѡ�źŸ�8λ
		RLC A
		MOV R1, A
		MOV DL, C                ;��λ����DL�������� 
		SETB CLK                 ;��λʱ�������أ���λ�Ĵ����洢����
		DJNZ R5, SHIFT_H         ;ѭ��8��
		MOV R0, DATA_L
		MOV R1, SELECT_L
		MOV R5, #8
SHIFT_L:
		MOV A, R0                ;ͬ�ϣ�������ģ���ݵ�8λ
		RLC A
		MOV R0, A
		MOV DH, C
		CLR CLK
		MOV A, R1                ;ͬ�ϣ�������ѡ�źŵ�8λ
		RLC A
		MOV R1, A
		MOV DL, C
		SETB CLK                 ;��λʱ�������أ���λ�Ĵ����洢����
		DJNZ R5, SHIFT_L         ;ѭ��8��
		SETB STR                 ;���źŵ�8λ��λ�Ĵ���ϣ�����ʱ�������أ�������λ�洢��״ֵ̬
		RET

DELAY1MS:			;�ӳ�1MS
		PUSH 30H
		PUSH 31H
		MOV 30H,#9
		MOV 31H,#150
NEXT1:
		DJNZ 31H,NEXT1
		DJNZ 30H,NEXT1
		POP 31H
		POP 30H
		RET

       ORG 2000H	      ;�����ģ��������,�е���Ч	//���룬���У�����
       DB  0DFH, 0FBH, 0DFH, 0F7H,  01H, 0C0H, 06fH, 0FBH, 06FH, 0DCH, 017H, 0DFH, 0FBH, 0C0H, 0DCH, 0FDH
       DB  0DFH, 0FDH, 003H, 0E0H, 0DFH, 0FDH, 0DFH, 0FDH, 00H,  080H, 0EFH, 0FBH, 0F7H, 0F7H, 0FBH, 0EFH;"��",0
       DB  0DFH, 0FBH, 0DFH, 0F7H,  01H, 0C0H, 06fH, 0FBH, 06FH, 0DCH, 017H, 0DFH, 0FBH, 0C0H, 0DCH, 0FDH
       DB  0DFH, 0FDH, 003H, 0E0H, 0DFH, 0FDH, 0DFH, 0FDH, 00H,  080H, 0EFH, 0FBH, 0F7H, 0F7H, 0FBH, 0EFH;"��",0

       ORG 2200H     ;�����ѡ�ź�����,�и���Ч
       DB 00H, 01H, 00H, 02H, 00H, 04H, 00H, 08H, 00H, 10H, 00H, 20H, 00H, 40H, 00H, 80H
	   DB 01H, 00H, 02H, 00H, 04H, 00H, 08H, 00H, 10H, 00H, 20H, 00H, 40H, 00H, 80H, 00H

	   END
