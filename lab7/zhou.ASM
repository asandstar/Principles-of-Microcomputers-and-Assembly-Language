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
//ROWTAB:
//;行扫描 逐行从左到右 逐行式
//
//DB 0DFH,0FEH,0DFH,0FEH,0DFH,0FDH,0DFH,0FDH,0D9H,0FBH,00EH,077H,0DFH,0AFH,0DFH,0DFH;
//DB 0DFH,0AFH,00EH,077H,0D1H,0FBH,0DFH,0FDH,0DFH,0FDH,0DFH,0FEH,0DFH,0FEH,0FFH,0FFH;"艾",0
//
//
//
////		DB 80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H,00H
////		DB 00H,80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H	//行高有效，列低有效
//COLTAB:		  //阳码，顺向，逐行
//		DB 0FBH, 0BFH, 0C0H, 007H, 0FBH, 0BFH, 0FBH, 0BFH, 000H, 001H, 0FEH, 0FFH, 0E0H, 00FH, 0EEH, 0EFH
//		DB 0EEH, 0EFH, 0E0H, 00FH, 0EEH, 0EFH, 0EEH, 0EFH, 0E0H, 00FH, 0FBH, 0BFH, 0F7H, 0DFH, 0EFH, 0EFH
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
//		END
//
	DH bit P1.0         ;串行输入行数据信号（采用行编码）
	DL bit P1.1         ;串行输入行选信号
	CLK bit P1.2        ;移位时钟信号SCK
	STR bit P1.3        ;锁存时钟信号RCLK
	OE bit P1.4         ;输出使能信号
	SELECT_H EQU 41H    ;行选通信号高8位
	SELECT_L EQU 42H    ;行选通信号低8位
	DATA_H EQU 43H      ;行数据信号高8位
	DATA_L EQU 44H      ;行数据信号低8位
	TIME EQU 45H        ;记录每帧延迟时间
	ROW_DATA EQU 2000H        ;字模数据表
	ROW_SELECT EQU 2200H      ;行选数据表

       ORG 0000H
       LJMP MAIN
       ORG 0100H
MAIN:	
        MOV 46H, #00H            ;存放已经滚动的行数
		MOV R3, #00H             ;行数据信号偏移量
		MOV R4, #00H             ;行选通信号偏移量
START:	
        MOV TIME, #30            ;每帧显示30次
ROLL:
		MOV R4, #00H
		MOV A, 46H
        MOV R3, A
        MOV R2, #10H             ;计数16次
LOAD: 
       MOV DPTR, #ROW_DATA      ;查字模数据表
		MOV A, R3
		MOVC A, @A+DPTR
		MOV DATA_H, A            ;载入行数据信号高8位
		INC R3
		MOV A, R3
		MOVC A, @A+DPTR
		MOV DATA_L, A            ;载入行数据信号低8位
		INC R3
		MOV DPTR, #ROW_SELECT    ;查行选通信号表
		MOV A, R4
		MOVC A, @A+DPTR
		MOV SELECT_H, A          ;载入行选通信号高8位
		INC R4
		MOV A, R4
		MOVC A, @A+DPTR
		MOV SELECT_L, A          ;载入行选通信号低8位
		INC R4
		ACALL SHIFT
		ACALL DELAY1MS
		DJNZ R2, LOAD            ;循环16次
		DJNZ TIME, ROLL
		MOV A, 46H
		INC A
		INC A
		MOV 46H, A
		CJNE A, #20H, START     ;滚动16行后从头开始
		LJMP MAIN

SHIFT:	                         ;串行输入程序
		CLR OE                   ;允许输出
		CLR STR
		MOV R0, DATA_H
		MOV R1, SELECT_H
		MOV R5, #8               ;8位计数8次
SHIFT_H:
		MOV A, R0                ;更新字模数据高8位
		RLC A                    ;循环左移1位
		MOV R0, A
		MOV DH, C                ;进位赋给DH串行输入
		CLR CLK
		MOV A, R1                ;更新行选信号高8位
		RLC A
		MOV R1, A
		MOV DL, C                ;进位赋给DL串行输入 
		SETB CLK                 ;移位时钟上升沿，移位寄存器存储数据
		DJNZ R5, SHIFT_H         ;循环8次
		MOV R0, DATA_L
		MOV R1, SELECT_L
		MOV R5, #8
SHIFT_L:
		MOV A, R0                ;同上，更新字模数据低8位
		RLC A
		MOV R0, A
		MOV DH, C
		CLR CLK
		MOV A, R1                ;同上，更新行选信号低8位
		RLC A
		MOV R1, A
		MOV DL, C
		SETB CLK                 ;移位时钟上升沿，移位寄存器存储数据
		DJNZ R5, SHIFT_L         ;循环8次
		SETB STR                 ;两信号的8位移位寄存完毕，锁存时钟上升沿，锁存移位存储器状态值
		RET

DELAY1MS:			;延迟1MS
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

       ORG 2000H	      ;存放字模数据两遍,列低有效	//阳码，逐行，逆向
       DB  0DFH, 0FBH, 0DFH, 0F7H,  01H, 0C0H, 06fH, 0FBH, 06FH, 0DCH, 017H, 0DFH, 0FBH, 0C0H, 0DCH, 0FDH
       DB  0DFH, 0FDH, 003H, 0E0H, 0DFH, 0FDH, 0DFH, 0FDH, 00H,  080H, 0EFH, 0FBH, 0F7H, 0F7H, 0FBH, 0EFH;"龚",0
       DB  0DFH, 0FBH, 0DFH, 0F7H,  01H, 0C0H, 06fH, 0FBH, 06FH, 0DCH, 017H, 0DFH, 0FBH, 0C0H, 0DCH, 0FDH
       DB  0DFH, 0FDH, 003H, 0E0H, 0DFH, 0FDH, 0DFH, 0FDH, 00H,  080H, 0EFH, 0FBH, 0F7H, 0F7H, 0FBH, 0EFH;"龚",0

       ORG 2200H     ;存放行选信号数据,行高有效
       DB 00H, 01H, 00H, 02H, 00H, 04H, 00H, 08H, 00H, 10H, 00H, 20H, 00H, 40H, 00H, 80H
	   DB 01H, 00H, 02H, 00H, 04H, 00H, 08H, 00H, 10H, 00H, 20H, 00H, 40H, 00H, 80H, 00H

	   END

