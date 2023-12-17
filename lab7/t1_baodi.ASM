//		DL EQU P1.0         ;串行输入行信号（选通）
//		DH EQU P1.1         ;串行输入列信号（数据）
//		CLK EQU P1.2        ;移位时钟信号SCLK
//		STR EQU P1.3        ;锁存时钟信号RCK
//		OE EQU P1.4         ;输出使能信号
//		ROW_H EQU 41H   	;行信号高8位（选通）
//		ROW_L EQU 42H   	;行信号低8位（选通）
//		COL_H EQU 43H     	;列信号高8位（数据）
//		COL_L EQU 44H     	;列信号低8位（数据）
//		ORG 0000H
//		LJMP MAIN
//		ORG 0100H		
//
//		ORG 0200H
//MAIN:
//		MOV R1, #01H 			;行开始扫描的位置
//		MOV R2, #01H 			;列开始扫描的位置
//		MOV R3, #10H 			;循环次数，16 次
//LOOP: 
//		MOV DPTR, #ROWTAB 		;寻找行开始扫描的信号
//		MOV A, R1
//		MOVC A, @A+DPTR 		;查表
//		MOV ROW_H, A 			;存储行的高字节
//		DEC R1 					;R1减1指向扫描该行的低字节
//		MOV A, R1 
//		MOVC A,@A+DPTR 			;查表
//		MOV ROW_L, A 			;存储行的低字节
//		INC R1
//		INC R1
//		INC R1 					;指向下一个行信号的高字节
//		MOV DPTR, #COLTAB 		;寻找列开始扫描的信号
//		MOV A, R2
//		MOVC A, @A+DPTR 		;查表
//		MOV COL_H, A 			;存储列信号的高字节
//		DEC R2 					;R2减一指向扫描该列的低字节
//		MOV A, R2
//		MOVC A, @A+DPTR 		;查表
//		MOV COL_L, A 			;存储列的低字节
//		INC R2
//		INC R2
//		INC R2 					;指向下一个列信号的高字节
//		LCALL LOCK 				;调用锁存数据的子程序
//		LCALL DELAY1MS 			;延时,导通二极管需要一定时间，不可扫描过快
//		DJNZ R3, LOOP 			;判断是否行扫描完
//		LJMP MAIN 				;16 行扫描完毕，回主程序继续循环
//LOCK: 							;锁存数据子程序
//		CLR OE 					;允许输出
//		CLR STR					;等待锁存入数据寄存器
//		MOV R4, ROW_H 			;R4存储行高位
//		MOV R5, COL_H 			;R5存储列高位
//		MOV R6, #8 				;8次循环
//LOCKH: 
//		CLR CLK 				;移位寄存器准备
//		MOV A, R4
//		RRC A 					;移出最高位
//		MOV R4, A
//		MOV DL, C 				;P1.0行输入
//		MOV A, R5
//		RRC A
//		MOV R5, A
//		MOV DH, C 				;P1.1列输入
//		SETB CLK 				;行列高位数据进入移位寄存器
//		NOP 					;等待几个时钟周期，保证数据正确进入锁存器
//		DJNZ R6, LOCKH 			;判断8位移完没有
//		
//		MOV R4, ROW_L 			;R4 存储行低位
//		MOV R5, COL_L 			;R5 存储列低位
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
//		SETB STR 				;存入数据寄存器
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

	HL EQU 30H ;行 低位
	HH EQU 31H ;行 高位
	LL EQU 32H ;列 低位
	LH EQU 33H ;列 高位
	
	DL EQU P1.0	;列输入
	DH EQU P1.1	;行输入
	CLK EQU P1.2 ;移位寄存器时钟	SRCLK
	STR EQU P1.3 ;锁存器时钟		RCLK
	OE EQU P1.4 ;输出使能

	ORG 0000H
	LJMP MAIN
	ORG 0100H

MAIN:
	 MOV DPTR,#WORDTAB ;字模表地址
	 MOV R1,#00H ;地址偏移
	 MOV HL,#01H ;第一行  0000 0001B
	 MOV HH,#00H ;不扫
LOOP:
	MOV A,R1 ;地址偏移初值
	MOVC A,@A+DPTR ;取字模
	MOV LL,A;读列低八位
	INC R1;准备读高八位

	MOV A,R1;地址偏移初值
	MOVC A,@A+DPTR ;取字模
	MOV LH,A;读列高八位

	LCALL HC595
	LCALL DELAY ;延时
	CLR C

	MOV A,HL;行低八位
	RLC A ;左移到下一行，如0000 0010B，0000 0100B
	MOV HL,A;更新行低八位

	MOV A,HH;行高八位
	RLC A ;左移到下一行
	MOV HH,A;更新行高八位

	INC R1
	CJNE R1,#20H,LOOP
	LJMP MAIN


HC595:
	CLR OE ;低电平有效
	CLR STR
	MOV R2, #08H  ;在SHIFT1移动八位
	MOV R3,LH ;列高8位
	MOV R4,HH ;行高8位
SHIFT1:
	CLR CLK
	MOV A,R3 ;列逐位传
	RLC A	 ;左移到下一列
	MOV R3,A 
	MOV DH,C ;列输入

	MOV A,R4 ;行逐位传
	RLC A	 ;左移到下一行
	MOV R4,A
	MOV DL,C

	SETB CLK ;上升沿移入数据进寄存器
	DJNZ R2,SHIFT1 ;不为0，继续移位
	MOV R2,#08H ;为0，重新赋值，在SHIFT2移动八位
	MOV R3,LL ;列低8位
	MOV R4,HL ;行低8位
SHIFT2:
	CLR CLK
	MOV A,R3 ;列逐位传
	RLC A	 ;左移到下一列
	MOV R3,A 
	MOV DH,C ;列输入

	MOV A,R4 ;行逐位传
	RLC A	 ;左移到下一行
	MOV R4,A
	MOV DL,C

	SETB CLK ;上升沿移入数据进寄存器
	DJNZ R2,SHIFT2 ;不为0，继续移位
	SETB STR ;寄存器数据移入锁存器
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
DB 0DFH,0FDH,0BFH,0FEH,07FH,0FFH,0BFH,0FEH,0DFH,0FDH,0EFH,0FBH,0F3H,0E7H,0FCH,09FH;"艾",0
	END
