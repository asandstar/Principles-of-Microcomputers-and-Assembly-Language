	DL EQU P1.0			;������
	DH EQU P1.1			;������ 
	SCK EQU  P1.2        ;��λ�Ĵ��� 
	RCK EQU  P1.3        ;������  
	OE EQU  P1.4         ;ʹ�ܶ�  

	HL EQU 30H ;�� ��λ
	HH EQU 31H ;�� ��λ
	LL EQU 32H ;�� ��λ
	LH EQU 33H ;�� ��λ
		  
	ORG  0000H                 
	LJMP  MAIN  
	ORG  0100H                 
MAIN:  
	MOV   DPTR,#WORDTAB  ;��ģ����ַ  
	MOV   R1,#00H          
	MOV   R7,#00H       ;R7������ʾ��ģ����ʼλ��ƫ����  
LOOP:  
	MOV   R5,#20         ;R5������ʾ��ʱ���ı�R5��ֵ�ɸı�����ٶ�                
LOOP1:  
	MOV   R6,#10H        ;R6�����ж��Ƿ�ɨ����һ��  
	MOV   A,R7              ;��R7��ֵ��ֵ��R1  
	MOV   R1,A  
	MOV   HL,#01H        ;��ɨ���źŵĳ�ֵ0001H  
	MOV   HH,#00H  
LOOP2:  
	MOV   A,R1  
	MOVC  A,@A+DPTR    
	MOV   LL,A           ;�ҵ��е�λ���ݣ������ڴ��ַ��  
	INC   R1  
	MOV   A,R1  
	MOVC  A,@A+DPTR  
	MOV   LH,A         ;�ҵ��и�λ���ݣ������ڴ��ַ��  
	LCALL HC595           ;���ô������ݵĳ���   
	LCALL DELAY           ;������ʱ����  
	CLR   C               ;λ�����ۼ�������  
    MOV   A,HL  
	RLC   A               ;������ɨ���źŵͰ�λ  
	MOV   HL,A  
	MOV   A,HH      
	RLC   A               ;������ɨ���źŸ߰�λ  
	MOV   HH,A  
	INC   R1  
    DEC   R6  
	CJNE  R6,#00H,LOOP2   ;ͨ��R6�ж��Ƿ�ɨ����һ�֣�R6��Ϊ0��һ��ɨ�����  
	DJNZ  R5,LOOP1        ;ͨ��R5�ж�һ֡����ʱ�Ƿ�ﵽ 
	//1 
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//2
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//3
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//4
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//5
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//6
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//7
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//8
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//9
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//10
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//11
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//12
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//13
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//14
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//15
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	//16
	INC   R7              ;�ı���ģ����ƫ����  
	INC   R7              ;R7������2���൱�ڻ���
	        
	CJNE  R7,#40H,LOOP    ;�ж���ģ���Ƿ����  
    LJMP  MAIN  
	
		  
HC595:  
	CLR   OE             ;ʹ���źŵ͵�ƽ��Ч  
	CLR   RCK            ;RCK�ź���0  
	MOV   R2,#08H  
	MOV   R3,LH        ;���źŸ�8λ��ַ  
	MOV   R4,HH        ;���źŸ�8λ��ַ  
BACK:  
	CLR   SCK             ;SCK�ź���0   
	MOV   A,R3  
	RLC   A  
	MOV   R3,A  
	MOV   DH,C           ;���ź���λ����  
	MOV   A,R4  
	RLC   A  
	MOV   R4,A  
	MOV   DL,C           ;���ź���λ����  
	SETB  SCK             ;SCK�ź������ص���������������������λ�Ĵ���  
	DJNZ  R2,BACK         ;�жϸ߰�λ�ź��Ƿ������  
	MOV   R2,#08H    
	MOV   R3,LL          ;���źŵͰ�λ��ַ  
	MOV   R4,HL          ;���źŵͰ�λ��ַ  
BACK1:  
	CLR  SCK              ;SCK�ź���0  
	MOV  A,R3  
	RLC  A  
	MOV  R3,A  
	MOV  DH,C            ;���ź���λ����  
	MOV  A,R4  
	RLC  A  
	MOV  R4,A  
	MOV  DL,C            ;���ź���λ����  
	SETB SCK               ;SCK�ź������ص���������������������λ�Ĵ���  
	DJNZ R2,BACK1          ;�жϵͰ�λ�ź��Ƿ������  
	SETB RCK               ;RCK�ź������ص�������λ�Ĵ������������������ݼĴ���  
	RET    
DELAY:                     ;��ʱ�ӳ���  
	MOV  R2,#50    
DELAY1:  
	MOV  R3,#10  
DELAY2:  
	DJNZ R3,$  
	DJNZ R2,DELAY1  
	RET  
WORDTAB:
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,00FH,0F9H,06FH,0F0H,0EFH,0F7H;
DB 0CFH,0F3H,09FH,0F9H,03FH,0FCH,07FH,0FEH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH;"h1",0
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,08FH,0F3H,067H,0C0H,0F7H,0DCH,0F7H,0DFH,0F7H,0CFH;
DB 0F7H,0EFH,0C7H,0E7H,0DFH,0F3H,01FH,0FBH,07FH,0F8H,0FFH,0FEH,0FFH,0FFH,0FFH,0FFH;"h2",0
//DB 0FFH,0FFH,083H,0C3H,03BH,099H,0F9H,03CH,0FDH,03FH,0FDH,03FH,0FDH,03FH,0F9H,03FH;
//DB 0F3H,0BFH,0F7H,09FH,0EFH,0CFH,0CFH,0EFH,09FH,0F3H,0BFH,0F9H,07FH,0FCH,0FFH,0FFH;"h3",0
	END