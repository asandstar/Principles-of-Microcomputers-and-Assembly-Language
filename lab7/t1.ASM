	DL EQU P1.0        ;DL����P1.0  
	DH EQU P1.1        ;DH����P1.1  
	CLK EQU P1.2       ;CLK����P1.2  
	STR EQU P1.3       ;STR����P1.3  
	OE EQU P1.4        ;OE����P1.4  
	ROWH EQU 40H       ;ROWH(40H)��ʾ��ǰ��ѡ�ĸ�8λ  
	ROWL EQU 41H       ;ROWL(41H)��ʾ��ǰ��ѡ�ĵ�8λ  
	COLH EQU 42H       ;COLH(42H)��ʾ��ǰ��ѡ�ĸ�8λ  
	COLL EQU 43H       ;COLL(43H)��ʾ��ǰ��ѡ�ĵ�8λ  
	ORG 0000H  
	LJMP MAIN  
	ORG 0050H  
COLHTAB: 
DB 20H ,02H ,20H ,02H ,0FFH ,7FH ,20H ,02H ,00H ,04H ,10H ,04H ,10H ,04H ,20H ,02H;


//DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH  
//         DB 0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH  ;��ѡ��8λ��  
COLLTAB: 
DB 20H ,02H ,40H ,01H ,80H ,00H ,40H ,01H ,20H ,02H ,10H ,04H ,0CH ,18H ,03H ,60H;"��",0
//DB 0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH  
//	     DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH ;��ѡ��8λ��  
ROWHTAB: 
DB 20H ,02H ,20H ,02H ,0FFH ,7FH ,20H ,02H ,00H ,04H ,10H ,04H ,10H ,04H ,20H ,02H;

//DB 00H,0FFH,04H,08H,07H,20H,11H,0DH  
//	     DB 41H,81H,7FH,01H,05H,09H,30H,00H         ;��ѡ��8λ��  
ROWLTAB: 
DB 20H ,02H ,40H ,01H ,80H ,00H ,40H ,01H ,20H ,02H ,10H ,04H ,0CH ,18H ,03H ,60H;"��",0
//DB 00H,0FEH,22H,5AH,86H,08H,88H,68H  
//	     DB 18H,0FH,0E8H,08H,08H,08H,08H,00H        ;��ѡ��8λ��  
      
	ORG 0300H  
MAIN:      
	MOV R7,#0                      ;R7Ϊ��ָ�룬���ڲ��С��б�  
LOOP:  
	MOV A,R7  
	MOV DPTR,#ROWHTAB  
	MOVC A,@A+DPTR  
	MOV ROWH,A                     ;��ǰ��ѡ��8λ����ROWH  
	MOV A,R7  
	MOV DPTR,#ROWLTAB  
	MOVC A,@A+DPTR  
	MOV ROWL,A                     ;��ǰ��ѡ��8λ����ROWL  
	MOV A,R7  
	MOV DPTR,#COLHTAB  
	MOVC A,@A+DPTR  
	MOV COLH,A                     ;��ǰ��ѡ��8λ����COLH  
	MOV A,R7  
	MOV DPTR,#COLLTAB  
	MOVC A,@A+DPTR  
	MOV COLL,A                     ;��ǰ��ѡ��8λ����COLL  
	ACALL DISP                     ;��ʾ��ǰ��(��ɨ��)
	INC R7                         ;���ָ��ָ����һ��ַ  
	CJNE R7,#16,LOOP               ;�ж�16���Ƿ�ɨ����  
	SJMP MAIN  
	  
DISP:                                   ;��ʾ�ӳ���  
	MOV R6,ROWH                      
	MOV R5,COLH  
	MOV R4,#08H                    ;R4���ڼǴ���λ��  
	ACALL INPUT                    ;�С��еĸ�8λ����74HC595  
	MOV R6,ROWL  
	MOV R5,COLL  
	         MOV R4,#08H                    ;R4���ڼǴ���λ��  
	         ACALL INPUT                    ;�С��еĵ�8λ����74HC595  
	         ACALL OUTPUT                   ;74HC595���������LED����  
	         RET                            ;�ӳ��򷵻�  
	           
INPUT:                                  ;74HC595�����뺯��       

STORE:   CLR CLK                        ;����CLK  
	         MOV A,R6  
	         RLC A  
	         MOV DL,C                       ;������ѡ�źţ���λ-��λ  
	         MOV R6,A  
	         MOV A,R5  
	         RLC A  
	         MOV DH,C                       ;������ѡ�źţ���λ-��λ  
	         MOV R5,A  
	         SETB CLK                       ;����CLK��������λ�Ĵ���  
	         DJNZ R4,STORE                  ;�ж�8λ�����Ƿ�������  
	         RET                            ;�Ӻ�������  
	  
	OUTPUT:                                 ;�������������LED����  
	         SETB OE                        ;����OE����ֹ���  
	         CLR STR                        ;����STR  
	         SETB STR                       ;����STR,���������������  
	         CLR OE                         ;����OE�����������LED����  
	         ACALL DELAY500US               ;��ʱ������500US  
	         RET                            ;�Ӻ�������  
	           
	DELAY500US:                             ;��ʱ500US 
	         NOP  
	         PUSH 30H  
	         PUSH 31H  
         	 MOV 30H,#5  
	         MOV 31H,#72  
	NEXT:  
	         DJNZ 31H,NEXT  
	         DJNZ 30H,NEXT  
	         POP 31H  
	         POP 30H  
	         RET  
	  
         END                            ;�������  