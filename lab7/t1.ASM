	DL EQU P1.0        ;DL连接P1.0  
	DH EQU P1.1        ;DH连接P1.1  
	CLK EQU P1.2       ;CLK连接P1.2  
	STR EQU P1.3       ;STR连接P1.3  
	OE EQU P1.4        ;OE连接P1.4  
	ROWH EQU 40H       ;ROWH(40H)表示当前行选的高8位  
	ROWL EQU 41H       ;ROWL(41H)表示当前行选的低8位  
	COLH EQU 42H       ;COLH(42H)表示当前列选的高8位  
	COLL EQU 43H       ;COLL(43H)表示当前列选的低8位  
	ORG 0000H  
	LJMP MAIN  
	ORG 0050H  
COLHTAB: 
DB 20H ,02H ,20H ,02H ,0FFH ,7FH ,20H ,02H ,00H ,04H ,10H ,04H ,10H ,04H ,20H ,02H;


//DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH  
//         DB 0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH  ;列选高8位表  
COLLTAB: 
DB 20H ,02H ,40H ,01H ,80H ,00H ,40H ,01H ,20H ,02H ,10H ,04H ,0CH ,18H ,03H ,60H;"艾",0
//DB 0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH  
//	     DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH ;列选低8位表  
ROWHTAB: 
DB 20H ,02H ,20H ,02H ,0FFH ,7FH ,20H ,02H ,00H ,04H ,10H ,04H ,10H ,04H ,20H ,02H;

//DB 00H,0FFH,04H,08H,07H,20H,11H,0DH  
//	     DB 41H,81H,7FH,01H,05H,09H,30H,00H         ;行选高8位表  
ROWLTAB: 
DB 20H ,02H ,40H ,01H ,80H ,00H ,40H ,01H ,20H ,02H ,10H ,04H ,0CH ,18H ,03H ,60H;"艾",0
//DB 00H,0FEH,22H,5AH,86H,08H,88H,68H  
//	     DB 18H,0FH,0E8H,08H,08H,08H,08H,00H        ;行选低8位表  
      
	ORG 0300H  
MAIN:      
	MOV R7,#0                      ;R7为表指针，用于查行、列表  
LOOP:  
	MOV A,R7  
	MOV DPTR,#ROWHTAB  
	MOVC A,@A+DPTR  
	MOV ROWH,A                     ;当前行选高8位存于ROWH  
	MOV A,R7  
	MOV DPTR,#ROWLTAB  
	MOVC A,@A+DPTR  
	MOV ROWL,A                     ;当前行选低8位存于ROWL  
	MOV A,R7  
	MOV DPTR,#COLHTAB  
	MOVC A,@A+DPTR  
	MOV COLH,A                     ;当前列选高8位存于COLH  
	MOV A,R7  
	MOV DPTR,#COLLTAB  
	MOVC A,@A+DPTR  
	MOV COLL,A                     ;当前列选低8位存于COLL  
	ACALL DISP                     ;显示当前列(列扫描)
	INC R7                         ;查表指针指向下一地址  
	CJNE R7,#16,LOOP               ;判断16列是否扫描完  
	SJMP MAIN  
	  
DISP:                                   ;显示子程序  
	MOV R6,ROWH                      
	MOV R5,COLH  
	MOV R4,#08H                    ;R4用于记传输位数  
	ACALL INPUT                    ;行、列的高8位输入74HC595  
	MOV R6,ROWL  
	MOV R5,COLL  
	         MOV R4,#08H                    ;R4用于记传输位数  
	         ACALL INPUT                    ;行、列的低8位输入74HC595  
	         ACALL OUTPUT                   ;74HC595输出，点亮LED点阵  
	         RET                            ;子程序返回  
	           
INPUT:                                  ;74HC595的输入函数       

STORE:   CLR CLK                        ;拉低CLK  
	         MOV A,R6  
	         RLC A  
	         MOV DL,C                       ;输入行选信号，高位-低位  
	         MOV R6,A  
	         MOV A,R5  
	         RLC A  
	         MOV DH,C                       ;输入列选信号，高位-低位  
	         MOV R5,A  
	         SETB CLK                       ;拉高CLK，输入移位寄存器  
	         DJNZ R4,STORE                  ;判读8位数据是否输入完  
	         RET                            ;子函数返回  
	  
	OUTPUT:                                 ;输出函数，驱动LED点阵  
	         SETB OE                        ;拉高OE，禁止输出  
	         CLR STR                        ;拉低STR  
	         SETB STR                       ;拉高STR,数存至输出锁存器  
	         CLR OE                         ;拉低OE，输出，驱动LED点阵  
	         ACALL DELAY500US               ;延时，驱动500US  
	         RET                            ;子函数返回  
	           
	DELAY500US:                             ;延时500US 
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
	  
         END                            ;程序结束  
