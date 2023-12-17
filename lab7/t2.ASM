/*
分别用静屏方式和滚屏方式显示自己的姓/名（单汉字，字体不限）。
     座位号为单数的同学用列扫描，且滚屏时自右向左
     座位号为双数的同学用行扫描，且滚屏时自上向下

	 花式显示：如逐渐放大的xin
*/

//zhangle
//静屏显示一
	HL EQU 70H ;行信号低位内存地址
	HH EQU 71H ;行信号高位内存地址
	LL EQU 72H ;列信号低位内存地址
	LH EQU 73H ;列信号高位内存地址
	
	DH EQU P1.0 ;行信号输入
	DL EQU P1.1 ;列信号输入
	SCK EQU P1.2 ;移位寄存器时钟
	OE EQU P1.3 ;输出使能
	RCK EQU P1.4 ;锁存器时钟
	
	ORG 0000H
	LJMP MAIN
	ORG 0100H
MAIN: MOV DPTR,#WORD ;字模表地址
	MOV R1,#00H ;地址偏移量
	MOV HL,#01H ;先扫第一行，初值 0001H
	MOV HH,#00H
LOOP: MOV A,R1
	MOVC A,@A+DPTR
	MOV LL,A ;读列信号低八位
	INC R1 ;偏移量+1
	MOV A,R1
	MOVC A,@A+DPTR
	MOV LH,A ;读列信号高 8 位
	LCALL SEND ;调用数据传输子程序
	LCALL DELAY ;延时
	CLR C
	MOV A,HL ;扫描下一行
	RLC A
	MOV HL,A
	MOV A,HH
	RLC A
	MOV HH,A
	INC R1 ;高低两次各+1
	CJNE R1,#20H,LOOP ;判断一轮扫描是否结束
	LJMP MAIN
SEND: CLR OE ;使能低电平有效
	CLR RCK
	MOV R2,#08H
	MOV R3,LH ;列信号高 8 位
	MOV R4,HH ;行信号高 8 位
BACK: CLR SCK
	MOV A,R3 ;列信号逐位传输
	RLC A
	MOV R3,A
	MOV DL,C
	MOV A,R4 ;行信号逐位传输
	RLC A
	MOV R4,A
	MOV DH,C
	SETB SCK ;SCK 上升沿，将串行数据移入寄存器
	DJNZ R2,BACK ;判断是否 8 位传输完毕
	MOV R2,#08H
	MOV R3,LL ;列信号低 8 位
	MOV R4,HL ;行信号低 8 位
BACK1: CLR SCK
	MOV A,R3
	RLC A
	MOV R3,A
	MOV DL,C ;列信号逐位传输
	MOV A,R4 ;行信号逐位传输
	RLC A
	MOV R4,A
	MOV DH,C
	SETB SCK ;SCK 上升沿，将串行数据移入寄存器
	DJNZ R2,BACK1 ;判断是否 8 位传输完毕
	SETB RCK ;RCK 上升沿，将寄存器数据移入锁存器
	RET
DELAY: 
	MOV R7,#50
DELAY1: 
	MOV R6,#10
DELAY2: 
	DJNZ R6,DELAY2
	DJNZ R7,DELAY1
	RET
WORD:
	DB	0FEH,0FFH,0FEH,0FFH,0EFH,03H,0FEH,0FFH,0FEH,0FFH,0E0H,07H,0EFH,0F7H,0EFH,0F7H
	DB	0EFH,0F7H,0E0H,07H,0EFH,0F7H,0EFH,0FFH,0DFH,0FFH,0DFH,0FFH,0BFH,0FFH,7FH,0FFH
	END 


//滚屏显示
//上下滚屏
	LL EQU  72H         ;列信号低位内存地址            
	HD EQU  P1.0         ;P1.0口连行信号输入端  
	LD EQU  P1.1         ;P1.1口连列信号输入端  
	SCK EQU  P1.2        ;P1.2口连移位寄存器  
	OE EQU  P1.3        ;P1.3口连使能端  
	RCK EQU  P1.4        ;P1.4口连锁存器  
	  
	ORG  0000H                 
	LJMP  MAIN  
	ORG  0100H                 
MAIN:  
	MOV   DPTR,#DISPLAY  ;字模表地址  
	MOV   R1,#00H          
	MOV R7,#00H       ;R7用来表示字模表起始位置偏移量  
LOOP:  
	MOV   R5,#20         ;R5用来表示延时，改变R5的值可改变滚屏速度                
LOOP1:  
	MOV   R6,#10H        ;R6用来判断是否扫描完一轮  
	MOV A,R7              ;将R7的值赋值给R1  
	MOV R1,A  
	MOV   HL,#01H        ;行扫描信号的初值0001H  
	MOV   HL+1,#00H  
LOOP2:  
	MOV   A,R1  
	MOVC  A,@A+DPTR    
	MOV   LL,A           ;找到列低位数据，存入内存地址中  
	INC   R1  
	MOV   A,R1  
	MOVC  A,@A+DPTR  
	MOV   LL+1,A         ;找到列高位数据，存入内存地址中  

	LCALL SENDD           ;调用传输数据的程序  
 
	LCALL DELAY           ;调用延时程序  
 
	CLR   C               ;位处理累加器清零  
    MOV   A,HL  
    RLC   A               ;左移行扫描信号低八位  
	MOV   HL,A  
	MOV   A,HL+1      
	RLC   A               ;左移行扫描信号高八位  
	MOV   HL+1,A  
	INC   R1  
    DEC   R6  
	CJNE  R6,#00H,LOOP2   ;通过R6判断是否扫描完一轮，R6减为0，一轮扫描结束  
	DJNZ  R5,LOOP1        ;通过R5判断一帧的延时是否达到  
	INC   R7              ;改变字模表的偏移量  
	INC   R7              ;R7连续加2，相当于换行  
	      
	CJNE  R7,#40H,LOOP    ;判断字模表是否结束  
    LJMP  MAIN  
	  
SENDD:  
    CLR   OE             ;使能信号低电平有效  
    CLR   RCK            ;RCK信号置0  
    MOV   R2,#08H  
    MOV   R3,LL+1        ;列信号高8位地址  
    MOV   R4,HL+1        ;行信号高8位地址  
BACK:  
    CLR   SCK             ;SCK信号置0   
    MOV   A,R3  
    RLC   A  
    MOV   R3,A  
	MOV   HD,C           ;列信号逐位传输  
	MOV   A,R4  
	RLC   A  
	MOV   R4,A  
	MOV   LD,C           ;行信号逐位传输  
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
	MOV  HD,C            ;列信号逐位传输  
	MOV  A,R4  
	RLC  A  
	MOV  R4,A  
	MOV  LD,C            ;行信号逐位传输  
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
  
DISPLAY:  
	DB 07FH, 0FFH, 060H, 0EFH, 06FH, 0EFH, 06FH, 0F7H, 06FH, 0FBH, 061H, 0FDH, 07DH, 0FFH, 01DH, 080H;  
	DB 07DH, 0FDH, 061H, 0FBH, 06FH, 0FBH, 06FH, 0F7H, 06FH, 0EFH, 06FH, 0DDH, 075H, 0BEH, 07BH, 0FFH;"张",0  
		  
	DB 0FFH, 0FBH, 0FFH, 0F0H, 007H, 0FFH, 0F7H, 0FFH, 077H, 0FFH, 07BH, 0FFH, 07BH, 0FFH, 003H, 0C0H;  
	DB 07FH, 0FFH, 06FH, 0FBH, 06FH, 0F7H, 077H, 0EFH, 07BH, 0DFH, 07DH, 0DFH, 05FH, 0FFH, 0BFH, 0FFH;"乐",0  
	
	END