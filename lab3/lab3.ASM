//1.�ֱ���STC15�Ķ�ʱ��/������T0��ģʽ0����ѯ��ʽ��
//��ʱ��/������T1��ģʽ1���жϷ�ʽ�����������źţ�
//Ƶ��Ϊ�����Լ�����λ�ż���4kHz���ҳ������޿ڵ�ַ��
//	//��ѯ��ʽ
//	ORG 0000H
//	LJMP MAIN
//
//	ORG 0100H
//MAIN:
//	AUXR2 EQU 8FH
//	MOV TMOD, #00H	    ; ģʽ0��16λ�Զ�����
//	ORL AUXR2, #01H     ;T1(P3.5)ʾ����������
//	MOV TH0,#0FFH		; ���ø��ֽڼ�����ֵ
//	MOV TL0,#8DH		; ���õ��ֽڼ�����ֵ
//	//
//	SETB P1.0			; ʾ���������˿�
//	SETB TR0			; ����T0��ʱ��
//	
//LOOP:
//	JNB TF0, LOOP		; ��ʱ��T0δ���������ѭ����ѯ
//	//CPL P1.0			; �����תP1.0
//	CLR TF0				; �����־λ����
//	SJMP LOOP			; ѭ����ѯ
//	SJMP $
//	END
//



//	//�жϷ�ʽ
//	ORG 0000H
//	LJMP MAIN
//	ORG 001BH			  ; �жϷ��������ڵ�ַ
//    LJMP INTT1			  ; ��ת���жϷ������
//
//	ORG 0100H
//MAIN:
//	MOV SP, #60H		; ���ö�ջ����
//	MOV TMOD, #10H		; ����T1Ϊģʽ1��16λ��ʱ����������ʽ1
//	MOV TH1,#0FFH		; ���ø��ֽڼ�����ֵ
//	MOV TL1,#8DH		; ���õ��ֽڼ�����ֵ
//	SETB P1.0			; ʾ���������˿�
//
//	SETB EA				; �����ж�
//	SETB ET1			; ������ʱ��T1�ж�
//
//	SETB TR1			; ����T1��ʱ��
//   	SJMP $
//
//	ORG 0200H 
//INTT1:
//	//CLR TF1 			; �����ʱ��T1�жϱ�־
//	PUSH ACC
//	PUSH DPL
//	PUSH DPH
//	MOV TH1,#0FAH		; ���ø��ֽڼ�����ֵ
//	MOV TL1,#9AH		; ���õ��ֽڼ�����ֵ
//	CPL P1.0
//	POP DPH
//	POP DPL
//	POP ACC
//	RETI
//
//	END




////�����źŷ�����������ͬƵ�η�����Ƶ�ʣ�����ͨ��RAM����ʾ10�������
//	COUNT EQU 60H
//	RESULT EQU 61H
//	ORG 0000H
//	LJMP MAIN
//
//	ORG 0100H
//MAIN:
//	MOV TMOD,#05H ; T0 - Mode 1, T1 - Mode 0
//	MOV TH0,#00H  ;T0����,��0��ʼ
//	MOV TL0,#00H  ;
//	MOV TH1,#4BH  ;T1��ʱ,50ms
//	MOV TL1,#0FDH
//	MOV COUNT, #20 ;��ʱ1s
//	//MOV RESULT, #9 ;�����Ѿ�����1��
//	SETB TR0  ;T0��������������źŷ�����
//	SETB TR1  ;T1��ʱ����
//	SETB P1.0
//	MOV R0,#30H;���8λ
//	MOV R1,#31H;���8λ
//CON:
//	JNB TF1, CON ;��ʱ50ms�������־λ=1����ִ�У�=0�������ʱ
//	CLR TF1;���T1�������־λ
//	DEC R2;������������
//	MOV A,COUNT;����ֵ�Ž�A�����ж�
//	JNZ CON;��������δ��20�Σ�������ʱ
//	CLR TR0;����ʱ��ﵽ1s��ֹͣ����
//	MOV @R0,TH0;R0ָ��ĵ�ַ����8λ
//	MOV @R1,TL0;R1ָ��ĵ�ַ����8λ
//
//	SJMP $
//	END
	COUNT EQU 60H
	ORG 0000H
	LJMP MAIN
	ORG 0100H
MAIN:
	MOV TMOD, #15H    ; T0 - Mode 1, T1 - Mode 0
    MOV TH0, #00H     ; T0����
    MOV TL0, #00H
    MOV TH1, #4BH       ;T1��ʱ,50ms 
    MOV TL1, #0FDH
    MOV COUNT, #20     ; ��������ʼ��Ϊ 0
    SETB TR0          ; ���� T0 ��ʱ��
    SETB TR1          ; ���� T1 ������
CON:
	JNB TF1, CON 	;��ʱ50ms�������־λ=1����ִ�У�=0�������ʱ
	CLR TF1			; �����־��0
    MOV TH1, # 4BH       ; T1��ʱ���ֶ����� 
    MOV TL1, # 0FDH
	DEC COUNT	   ;������������
	MOV A, COUNT   ;����ֵ�Ž�A�����ж�
	JNZ CON	   ;��������δ��20�Σ�������ʱ
	CLR TR0	   ;����ʱ��ﵽ1s��ֹͣ����
	MOV R2,TH0 ;���8λ
	MOV R3,TL0 ;���8λ
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
//    MOV TH0, #00H     ; T0����
//    MOV TL0, #00H
//    MOV TH1, #4BH       ; T1��ʱ 
//    MOV TL1, #0FDH
//    MOV COUNT, #20     ; ��������ʼ��Ϊ 0
//    //MOV RESULT, #0    ; �洢�����λ�ó�ʼ��Ϊ 0
//    SETB TR0          ; ���� T0 ��ʱ��
//    SETB TR1          ; ���� T1 ������
//	MOV R0,#30H;���8λ
//	MOV R1,#31H;���8λ
//CON:
//	JNB TF1, CON 	;��ʱ50ms�������־λ=1����ִ�У�=0�������ʱ
//	CLR TF1			; �����־��0
//    MOV TH1, #4BH       ; T1��ʱ 
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
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R1,A
//	DEC RESULT;���Դ�Ľ��������	
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
//	MOV @R0,TH0;R0ָ��ĵ�ַ����8λ
//	MOV @R1,TL0;R1ָ��ĵ�ַ����8λ
//	MOV A,R0
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R1,A
//	DEC RESULT;���Դ�Ľ��������
//	MOV A,RESULT
//	JNZ CON ;���û��10����������





////���� �洢��� �Ƿ���������ַ�ĳ��򣨳ɹ���
//	COUNT EQU 60H
//	ORG 0000H
//	LJMP MAIN
//
//	ORG 0100H
//MAIN:
//	MOV R0,#30H;���8λ
//	MOV R1,#31H;���8λ
//	
//	
//	MOV 70H,#01H
//	MOV 71H,#02H
//	MOV COUNT, #20;16+4 14H
//
//LOOP:
//	MOV @R0,70H;R0ָ��ĵ�ַ����8λ
//	MOV @R1,71H;R1ָ��ĵ�ַ����8λ
//	MOV A,R0
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R0,A
//	MOV A,R1
//	ADD A,#02H ;�����ƶ�������ַ
//	MOV R1,A
//	DEC COUNT
//	MOV A,COUNT
//	JNZ LOOP
//
//	SJMP $
//	END





////�ð������̿��ؿ��Ʋ���2����Ƶ�ź�ʹ������������
//	ORG 0000H
//	LJMP MAIN
//	ORG 0003H
//	LJMP INTEX0  ;�ⲿ�ж�0
//	ORG 000BH
//	LJMP INTT0 ;��ʱ���ж�0
//	ORG 0013H
//	LJMP INTEX1  ;�ⲿ�ж�1
//
//	ORG 0100H
//MAIN:
//	 MOV TMOD, #00H ;T0��T1,��ʽ0
//	 CLR IT0 ;INT0�½��ش���
//	 CLR IT1 ;INT1�½��ش���
//	 SETB EX0 ;�ⲿ�ж�0����
//	 SETB EX1  ;�ⲿ�ж�1����
//	 SETB EA   ;������Ƭ�����ж�
//	 SETB PX1 ;�����ⲿ�ж�1Ϊ�ж����ȼ�
//	 SETB ET0  ;T0�ж�����
//	 SETB TR0 ;T0��������
//
//LOOP:
//	SJMP LOOP
//
//	ORG 0200H
//INTEX0:
//	ACALL DELAY50MS	;��������
//	JB P3.2,RE1	 ;KEY1���£�����������һ��Ƶ������
//	MOV TH0,#0F9H
//	MOV TL0,#01EH
//RE1:
//	RETI
//INTEX1:
//	 ACALL DELAY50MS ;��������
//	 JB P3.3,RE2  ;KEY2���£�������������һ��Ƶ������
//	 MOV TH0,#0FBH
//	 MOV TL0,#0E8H
//RE2:
//	RETI
//
//INTT0:
//	CPL P1.0   ;��������
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
////�����ǲ�ѯ	  ��Ҫ����p3.2,p3.3
//�������ж�	  p3.2,p3.3
//��clear���ж�ָ��ѧ��ʹ��JVC