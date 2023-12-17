	DL EQU P1.0			;列输入
	DH EQU P1.1			;行输入 
	SCK EQU  P1.2        ;移位寄存器 
	RCK EQU  P1.3        ;锁存器  
	OE EQU  P1.4         ;使能端  

	HL EQU 30H ;行 低位
	HH EQU 31H ;行 高位
	LL EQU 32H ;列 低位
	LH EQU 33H ;列 高位
		  
	ORG  0000H                 
	LJMP  MAIN  
	ORG  0100H                 
MAIN:  
	MOV   DPTR,#WORDTAB  ;字模表地址  
	MOV   R1,#00H          
	MOV   R7,#00H       ;R7用来表示字模表起始位置偏移量  
LOOP:  
	MOV   R5,#20         ;R5用来表示延时，改变R5的值可改变滚屏速度                
LOOP1:  
	MOV   R6,#10H        ;R6用来判断是否扫描完一轮  
	MOV   A,R7              ;将R7的值赋值给R1  
	MOV   R1,A  
	MOV   HL,#01H        ;行扫描信号的初值0001H  
	MOV   HH,#00H  
LOOP2:  
	MOV   A,R1  
	MOVC  A,@A+DPTR    
	MOV   LL,A           ;找到列低位数据，存入内存地址中  
	INC   R1  
	MOV   A,R1  
	MOVC  A,@A+DPTR  
	MOV   LH,A         ;找到列高位数据，存入内存地址中  
	LCALL HC595           ;调用传输数据的程序   
	LCALL DELAY           ;调用延时程序  
	CLR   C               ;位处理累加器清零  
    MOV   A,HL  
	RLC   A               ;左移行扫描信号低八位  
	MOV   HL,A  
	MOV   A,HH      
	RLC   A               ;左移行扫描信号高八位  
	MOV   HH,A  
	INC   R1  
    DEC   R6  
	CJNE  R6,#00H,LOOP2   ;通过R6判断是否扫描完一轮，R6减为0，一轮扫描结束  
	DJNZ  R5,LOOP1        ;通过R5判断一帧的延时是否达到 
	//1 
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//2
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//3
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//4
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//5
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//6
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//7
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//8
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//9
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//10
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//11
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//12
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//13
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//14
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//15
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	//16
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行
	        
	CJNE  R7,#40H,LOOP    ;判断字模表是否结束  
    LJMP  MAIN  
	
		  
HC595:  
	CLR   OE             ;使能信号低电平有效  
	CLR   RCK            ;RCK信号置0  
	MOV   R2,#08H  
	MOV   R3,LH        ;列信号高8位地址  
	MOV   R4,HH        ;行信号高8位地址  
BACK:  
	CLR   SCK             ;SCK信号置0   
	MOV   A,R3  
	RLC   A  
	MOV   R3,A  
	MOV   DH,C           ;列信号逐位传输  
	MOV   A,R4  
	RLC   A  
	MOV   R4,A  
	MOV   DL,C           ;行信号逐位传输  
	SETB  SCK             ;SCK信号上升沿到来，将串行数据移入移位寄存器  
	DJNZ  R2,BACK         ;判断高八位信号是否传输完毕  
	MOV   R2,#08H    
	MOV   R3,LL          ;列信号低八位地址  
	MOV   R4,HL          ;行信号低八位地址  
BACK1:  
	CLR  SCK              ;SCK信号置0  
	MOV  A,R3  
	RLC  A  
	MOV  R3,A  
	MOV  DH,C            ;列信号逐位传输  
	MOV  A,R4  
	RLC  A  
	MOV  R4,A  
	MOV  DL,C            ;行信号逐位传输  
	SETB SCK               ;SCK信号上升沿到来，将串行数据移入移位寄存器  
	DJNZ R2,BACK1          ;判断低八位信号是否传输完毕  
	SETB RCK               ;RCK信号上升沿到来，移位寄存器的数据锁存入数据寄存器  
	RET    
DELAY:                     ;延时子程序  
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