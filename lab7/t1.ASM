///*
//使用导线将P1.0~P1.4与DL（行输入）、DH（列输入）、LCK、STR、/OE连接，在16×16LED点阵上分别用静屏显示和滚屏显示方式显示自己的姓。
//*/
//     ORG 0000H
//     LJMP MAIN
//     ORG 000BH
//     LJMP TIMER0
//     ORG 0100H
//MAIN:
//     LCALL INITIAL        ;将字形码存在30H开始的单元
//     MOV R7,#00H       ;R7用来控制定时器溢出次数
//     MOV SP,#60H        ;设置堆栈指针
//     MOV TMOD,#01H     ;定时器0工作在工作方式1
//     MOV TH0,#00H 
//     MOV TL0,#00H        ;定时器0赋初值
//     SETB PT0             ;定时器中断0优先级为高
//     SETB ET0             ;允许定时器中断零
//     SETB EA              ;开放所有中断允许
//     SETB TR0             ;启动定时器
//XIANSHI:                  ;显示程序
//     MOV R6,#00H         ;R6记录当前行号
//     MOV R5,#00H         ;R5记录当前列号
//BACK1:
//     MOV A,R6       
//     MOV DPTR,#ROW0_TABLE  ;准备行信号前半段
//     MOVC A,@A+DPTR
//     MOV 50H,A               ;行信号低8位存在50H
//     MOV A,R6
//     MOV DPTR,#ROW1_TABLE
//     MOVC A,@A+DPTR
//     MOV 51H,A                 ;行信号高8位存在51H
//     MOV A,R5
//     MOV B,#30H
//     ADD A,B
//     MOV R0,A
//     MOV A,@R0
//     MOV 52H,A                ;列信号高8位存在52H
//     INC R5                    
//     MOV A,R5
//     MOV B,#30H
//     ADD A,B
//     MOV R0,A
//     MOV A,@R0
//     MOV 53H,A                ;列信号低8位存在53H
//     MOV R4,#08H              ;行列先向595输入高八位
//     MOV R3,51H               ;行高8位存在R3
//     MOV R2,52H                ;列高8位存在R2
//BACK2:
//     CLR P1.2                    ;移位寄存器状态保持
//     MOV A,R3
//     RLC A
//     MOV P1.0,C                  ;R3逐位输入到DL
//     MOV R3,A
//     MOV A,R2
//     RLC A
//     MOV P1.1,C                 ;R2逐位输入到DH
//     MOV R2,A
//     SETB P1.2                   ;移位寄存器读入当前输入
//     DJNZ R4,BACK2               ;未读完8位继续
//     MOV R4,#08H                ;向595中输入行列低8位
//     MOV R3,50H                 ;行低八位存在R3
//     MOV R2,53H                 ;列低八位存在R2
//BACK3:
//     CLR P1.2                     ;移位寄存器状态保持
//     MOV A,R3
//     RLC A
//     MOV P1.0,C                   ;R3逐位输入DL
//     MOV R3,A
//     MOV A,R2
//     RLC A
//     MOV P1.1,C                 ;R2逐位输入DH
//     MOV R2,A
//     SETB P1.2                   ;移位寄存器读入
//     DJNZ R4,BACK3               ;未完成8位继续
//     SETB OE                     ;关闭595输出，输出高阻
//     CLR STR                     ;先输出低电平
//     SETB STR       ;上升沿输出存储器锁存移位寄存器中状态值
//     CLR OE                       ;开放595输出允许
//     LCALL DELAY1M                ;延时1ms
//     INC R6
//     INC R5                        ;指向下一行列的值
//     CJNE R6,#10H,BACK1            ;16行未扫描完继续扫描
//     SJMP XIANSHI                  ;扫描完从头开始扫描
//INITIAL:                           ;字形码装入30H开始单元
//     MOV R0,#30H                 ;R0指向开始地址
//     MOV R7,#00H                 ;R7用于记录数据个数
//MOV_LOOP:
//     MOV DPTR,#CHAR_TABLE
//     MOV A,R7
//     MOVC A,@A+DPTR
//     MOV @R0,A                  ;数据转移至30H开始单元
//     INC R7                       ;计数加一
//     INC R0                       ;指向下一单元
//     CJNE R7,#20H,MOV_LOOP       ;32个字形码未转移完继续
//     RET                          
//TIMER0:                           ;定时器中断程序，静态显示不需要中断部分
//     CLR TR0                      ;暂停计数
//     INC R7                        ;溢出计数加一
//     CJNE R7,#0EH,JIXU              ;未溢出14次，不作处理
//     LCALL ROLL                    ;调用滚动程序
//     MOV R7,#00H                 ;计数归零
//JIXU:
//     MOV TH0,#00H
//     MOV TL0,#00H                  ;计数器从新赋值
//     SETB TR0                        ;继续计数
//     RETI
//ROLL:
//     PUSH ACC                       ;保护A值
//     MOV 70H,R3                     ;保护R3的值
//     MOV R1,#30H                    ;R1指向存储开始单元
//     MOV R3,#10H                    ;R3记录循环次数
//BACK4:
//     MOV A,@R1
//     RLC A                         ;列高八位左移
//     INC R1                        ;指向列低八位
//     MOV B,A                      ;B暂存左移后列高8位
//     MOV A,@R1                  
//     RLC A                         ;带进位左移列低八位
//     MOV @R1,A                   ;新低八位存回（R1）
//     MOV A,B                      ;A存列左移后高八位
//     JC   C1                       ;C为1跳转
//     ANL A,#0FEH                   ;C为0高八位最低位填0
//     SJMP C0
//C1:
//     ORL A,#01H                    ;C为1高八位最低位填1
//C0:
//     DEC R1                      ;R1指向高八位存储单元
//     MOV @R1,A                 ;存回(R1)
//     INC R1
//     INC R1                       ;指向下一列
//     DJNZ R3,BACK4                ;16列未移动完继续
//     MOV R3,70H                  ;返回进入中断保存的R3值
//     POP ACC                      ;返回保存的A值
//     RET
//     
//DELAY1M:                           ;延时1ms程序
//     MOV R2,#20H
//DLOOP1:
//     MOV R3,#20H
//DLOOP0:
//     DJNZ R3,DLOOP0
//     DJNZ R2,DLOOP1
//     RET
//ROW0_TABLE:    ;行低八位
//     DB 00000001B,00000010B,00000100B,00001000B,00010000B,00100000B,01000000B,10000000B
//     DB 00H,00H,00H,00H,00H,00H,00H,00H
//ROW1_TABLE:     ;行高八位
//     DB 00H,00H,00H,00H,00H,00H,00H,00H
//     DB 00000001B,00000010B,00000100B,00001000B,00010000B,00100000B,01000000B,10000000B
//CHAR_TABLE:     ;字形码
//     DB 0FFH,0FFH,0FFH,0FFH,0FCH,0CFH,0FDH,0EFH,080H,07H
//     DB 0FDH,0F3H,0C0H,005H,0FDH,0F7H,0C0H,07H,0FDH,0F7H,080H,07H
//     DB 0DFH,0F7H,0DBH,0B7H,0BBH,0BBH,77H,79H,0FFH,0FFH
//END
//

////2
////静态
//		ROWH	EQU		40H
//		ROWL	EQU		41H
//		COLH	EQU		42H
//		COLL	EQU		43H
//
//		ORG		0000H
//		LJMP	MAIN
//
//		ORG		0100H
//MAIN:	MOV		R1, #01H 		; R1存行信号位置
//		MOV		R2, #01H		; R2存列信号位置
//		MOV		R3, #10H		; 共输出16行数据
//
//LOAD:							; 加载行列信号子程序
//		MOV		DPTR, #ROWTAB
//		MOV		A, R1			; 取行数据的高字节
//		MOVC	A, @A+DPTR
//		MOV		ROWH, A			; 加载行高字节
//		DEC		R1				; R1指向行信号的低字节
//		MOV		A, R1
//		MOVC	A, @A+DPTR
//		MOV		ROWL, A			; 加载行信号低字节
//		
//		INC		R1
//		INC		R1
//		INC		R1				; R1 + 3指向下一个行信号的高字节
//
//		MOV		DPTR, #COLTAB
//		MOV 	A, R2
//		MOVC	A, @A+DPTR
//		MOV		COLH, A			; 加载列信号高字节
//		DEC		R2				; R2指向列信号低字节
//		MOV		A, R2
//		MOVC	A, @A+DPTR
//		MOV		COLL, A			; 加载列信号低字节
//		
//		INC		R2
//		INC		R2
//		INC		R2				; R1 + 3指向下一个列信号的高字节
//		
//		LCALL	LATCH			; 调用锁存子程序
//
//DELAY1:	MOV		R7, #0FFH
//LOOP1:	MOV		R7, LOOP1		; 延时显示
//		
//		DJNZ	R3, LOAD		; 循环扫描完16行数据
//		LJMP	MAIN		
//
//; P1.0接DL，P1.1接DH，P1.2接CLK，P1.3接STR，P1.4接/OE。
//
//LATCH:	CLR		P1.4			; 拉低/OE，允许输出
//		CLR		P1.3			; 拉低RCLK，等待锁存入数据锁存器
//		MOV		R4, ROWH		; R4存行信号高字节
//		MOV		R5, COLH		; R5存列信号高字节
//		MOV		R6, #08H
//LATCH1:	CLR		P1.2			; 拉低SRCLK，准备输入数据
//		MOV		A, R4
//		RRC		A				; 行信号不断循环右移，对应LED灯高位到低位依次输进C
//		MOV		R4, A
//		MOV		P1.0, C			; 输出一行信号到端口
//		
//		MOV		A, R5	   		; 开始输入一个列信号
//		RRC		A
//		MOV		R5, A
//		MOV		P1.1, C
//		SETB	P1.2			; SRCLR上升沿锁存输入单个行信号和列信号
//		NOP						; 等待一拍，便于锁存稳定
//		DJNZ	R6, LATCH1		; 判断8位是否全部锁存
//		
//		MOV		R4, ROWL		; R4存行低字节
//		MOV		R5, COLL		; R5存列低字节
//		MOV		R6, #08H		; 循环8次
//LATCH2:	CLR		P1.2			; 拉低SRCLK，准备输入数据
//		MOV		A, R4
//		RRC		A				; 行信号不断循环右移，对应LED灯高位到低位依次输进C
//		MOV		R4, A
//		MOV		P1.0, C			; 输出一行信号到端口
//		
//		MOV		A, R5	   		; 开始输入一个列信号
//		RRC		A
//		MOV		R5, A
//		MOV		P1.1, C
//		SETB	P1.2			; SRCLR上升沿锁存输入单个行信号和列信号
//		NOP						; 等待一拍，便于锁存稳定
//		DJNZ	R6, LATCH2		; 判断8位是否全部锁存
//		
//		SETB	P1.3			; RCLK上升沿，锁存器输出，LED亮一行
//
//DELAY2:	MOV		R7, #0FFH
//LOOP2:	MOV		R7, LOOP2		; 延时显示
//		
//		RET	
//
//ROWTAB:	
//DB		80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H,00H
//DB		00H,80H,00H,40H,00H,20H,00H,10H,00H,08H,00H,04H,00H,02H,00H,01H
//			
//COLTAB:
//DB		0FEH,0FFH,0FEH,0FFH,80H,03H,0FCH,7FH,0FAH,0BFH,0F6H,0DFH,0CEH,0E7H,3EH,0F9H
//DB		0F0H,1FH,0FFH,0BFH,0FFH,7FH,00H,01H,0FEH,0FFH,0FEH,0FFH,0FAH,0FFH,0FDH,0FFH
//
//		END



////动态
//		ROWH	EQU		50H
//		ROWL	EQU		51H
//		COLH	EQU		52H
//		COLL	EQU		53H
//		FLAG	EQU		54H
//
//		ORG		0000H
//		LJMP	MAIN
//
//		ORG		0003H
//		LJMP	INT0P
//
//		ORG		0100H
//MAIN:	MOV 	95H, #0				;P2:95H,96H
//		MOV 	96H, #0FFH
//		LCALL	STATICCODE
//
//MLOOP:	MOV		A, FLAG
//
//UP:		CJNE	A, #00H, DOWN
//		LCALL	UPCODE
//		SJMP	XIANSHI
//
//DOWN:	CJNE	A, #01H, LEFT
//		LCALL	DOWNCODE
//		SJMP	XIANSHI
//
//LEFT:	CJNE	A, #02H, RIGHT
//		LCALL	LEFTCODE
//		SJMP	XIANSHI
//
//RIGHT:	CJNE	A, #03H, STATIC
//		LCALL	RIGHTCODE
//		SJMP	XIANSHI
//
//STATIC:	LCALL	STATICCODE
//
//		MOV		59H, #40H
//XIANSHI:
//		LCALL	DISPLAY
//		MOV		A, 59H
//		DEC		A
//		MOV		59H, A
//		JNZ		XIANSHI
//		
//		LJMP	MLOOP		
//
//DELAY10MS:		
//		MOV 	R7, #14H		;延时10ms
//DELAY1:	MOV		R6, #0E5H
//DELAY2:	DJNZ	R6, DELAY2
//		DJNZ	R7, DELAY1
//		DJNZ	R5, DELAY10MS
//
//		LJMP	MLOOP
//
//
//; 中断服务程序
//INT0P:	CLR		EA
//		ACALL	DELAY				; 延时去抖
//		MOV		A, #0FEH			; 从0行开启扫描
//FINDING:MOV		R2, A				; 保存行列输入状态到R2
//		MOV		P2, A				; 输出到P2
//		MOV		A, P2				; 读取行列线状态
//		ANL		A, #0F0H			; 仅保存列线状态
//		CJNE	A, #0F0H, KEYCODE	; 若某列不为1，则跳转至查找键程序
//		MOV		A, R2				; 该行扫描未果，进入下一行
//		RL		A					; 循环左移，扫描下一行
//		JNB		ACC.4, RETURN		; 行线扫描完毕，未找到键，返回
//BACK:	SJMP	FINDING
//
//KEYCODE:XCH 	A, R2
//		ANL 	A, #0FH
//		ORL 	A, R2 				; 使A为键特征值
//		MOV		55H, A				; 保存特征值到60H
//		MOV		DPTR, #KEYTAB		; 开始查找特征值对应键的标号
//		MOV		56H, #0FFH			; R3作为标号，初始化为0FFH,存放在56H中
//		
//SPEC:	MOV		R3, 56H
//		INC		R3					; R3自增
//		MOV		56H, R3
//		MOV		A, R3
//		CLR		C
//		SUBB	A, #10H
//		JZ		FINDING
//		MOV		A, R3				; R3自增
//		MOVC	A, @A+DPTR			; 对比表格中存储的特征值
//		CJNE	A, 55H, SPEC
//		MOV		FLAG, R3			; 保存按键值
//		
//WAIT:	MOV		A, P2	   			; 判断闭合键是否释放
//		CJNE	A, 55H, RETURN		; 若没释放继续等待，若释放跳转至MAKEFLAG
//		SJMP	WAIT
//
//RETURN:	MOV		P2, #0F0H
//		SETB	EA
//		RETI		
//
//; 静态数据
//STATICCODE:	
//		MOV		30H, #0FEH
//		MOV		31H, #0FFH
//		MOV		32H, #0FEH
//		MOV		33H, #0FFH
//		MOV		34H, #80H
//		MOV		35H, #03H
//		MOV		36H, #0FCH
//		MOV		37H, #7FH
//		
//		MOV		38H, #0FAH
//		MOV		39H, #0BFH
//		MOV		3AH, #0F6H
//		MOV		3BH, #0DFH
//		MOV		3CH, #0CEH
//		MOV		3DH, #0E7H
//		MOV		3EH, #3EH
//		MOV		3FH, #0F9H
//				
//		MOV		40H, #0F0H 
//		MOV		41H, #1FH
//		MOV		42H, #0FFH
//		MOV		43H, #0BFH
//		MOV		44H, #0FFH
//		MOV		45H, #7FH
//		MOV		46H, #00H
//		MOV		47H, #01H
//				
//		MOV		48H, #0FEH
//		MOV		49H, #0FFH
//		MOV		4AH, #0FEH
//		MOV		4BH, #0FFH
//		MOV		4CH, #0FAH
//		MOV		4DH, #0FFH
//		MOV		4EH, #0FDH
//		MOV		4FH, #0FFH
//
//		RET
//
//; 上滚动函数
//UPCODE:	MOV		R4, #30H
//		MOV		R5, #32H
//		MOV		R6, #0FH
//		MOV		A, 30H
//		MOV		57H, A
//		MOV		A, 31H
//		MOV		58H, A
//
//D0:		MOV		A, @R5
//		MOV		@R4, A
//		INC		R5
//		INC		R4
//		MOV		A, @R5
//		MOV		@R4, A
//		INC		R5
//		INC		R4
//		DJNZ	R6, D0
//		MOV		A, 57H
//		MOV		4EH, A
//		MOV		A, 58H
//		MOV		4FH, A
//		
//		RET			
//		
//
//
//; 下滚动函数
//DOWNCODE:	
//		MOV		R0, #4DH
//		MOV		R1, #4FH
//		MOV		R6, #0FH
//		MOV		A, 4EH
//		MOV		57H, A
//		MOV		A, 4FH
//		MOV		58H, A
//
//D1:		MOV		A, @R0
//		MOV		@R1, A
//		DEC		R0
//		DEC		R1
//		MOV		A, @R0
//		MOV		@R1, A
//		DEC		R0
//		DEC		R1
//		DJNZ	R6, D1
//		
//		MOV		A, 57H
//		MOV		30H, A
//		MOV		A, 58H
//		MOV		31H, A
//
//		RET		
//
//
//; 左滚动函数
//LEFTCODE:
//		MOV		R4, #30H
//		MOV		R5, #31H
//		MOV		R6, #10H
//
//D2:		MOV		A, @R5
//		MOV		C, ACC.7
//		MOV		A, @R4
//		RLC		A
//		MOV		@R4, A
//		MOV		A, @R5
//		RLC		A
//		MOV		@R5, A
//		INC		R4
//		INC		R4
//		INC		R5
//		INC		R5
//		DJNZ	R6, D2
//
//		RET
//
//; 右滚动函数	
//RIGHTCODE:
//		MOV		R4, #30H
//		MOV		R5, #31H
//		MOV		R6, #10H
//
//D3:		MOV		A, @R4
//		MOV		C, ACC.0
//		MOV		A, @R5
//		RRC		A
//		MOV		@R5, A
//		MOV		A, @R4
//		RRC		A
//		MOV		@R4, A
//		INC		R4
//		INC		R4
//		INC		R5
//		INC		R5
//		DJNZ	R6, D3
//
//		RET
//
//; 静态显示函数
//DISPLAY:
//		MOV		R1, #01H 		; R1存行信号位置
//		MOV		R2, #31H		; R2存列信号位置
//		MOV		R3, #10H		; 共输出16行数据
//
//LOAD:							; 加载行列信号子程序
//		MOV		DPTR, #ROWTAB
//		MOV		A, R1			; 取行数据的高字节
//		MOVC	A, @A+DPTR
//		MOV		ROWH, A			; 加载行高字节
//		DEC		R1				; R1指向行信号的低字节
//		MOV		A, R1
//		MOVC	A, @A+DPTR
//		MOV		ROWL, A			; 加载行信号低字节
//		
//		INC		R1
//		INC		R1
//		INC		R1				; R1 + 3指向下一个行信号的高字节
//
//		MOVC	A, @R2
//		MOV		COLH, A			; 加载列信号高字节
//		DEC		R2				; R2指向列信号低字节
//		MOVC	A, @R2
//		MOV		COLL, A			; 加载列信号低字节
//		
//		INC		R2
//		INC		R2
//		INC		R2				; R1 + 3指向下一个列信号的高字节
//		
//		LCALL	LATCH			; 调用锁存子程序
//		LCALL	DELAYLATCH
//		
//		DJNZ	R3, LOAD		; 循环扫描完16行数据
//		
//		RET		
//
//
//; 锁存函数
//
//LATCH:	CLR		P1.4			; 拉低/OE，允许输出
//		CLR		P1.3			; 拉低RCLK，等待锁存入数据锁存器
//		MOV		R4, ROWH		; R4存行信号高字节
//		MOV		R5, COLH		; R5存列信号高字节
//		MOV		R6, #08H
//LATCH1:	CLR		P1.2			; 拉低SRCLK，准备输入数据
//		MOV		A, R4
//		RRC		A				; 行信号不断循环右移，对应LED灯高位到低位依次输进C
//		MOV		R4, A
//		MOV		P1.0, C			; 输出一行信号到端口
//		
//		MOV		A, R5	   		; 开始输入一个列信号
//		RRC		A
//		MOV		R5, A
//		MOV		P1.1, C
//		SETB	P1.2			; SRCLR上升沿锁存输入单个行信号和列信号
//		NOP						; 等待一拍，便于锁存稳定
//		DJNZ	R6, LATCH1		; 判断8位是否全部锁存
//		
//		MOV		R4, ROWL		; R4存行低字节
//		MOV		R5, COLL		; R5存列低字节
//		MOV		R6, #08H		; 循环8次
//LATCH2:	CLR		P1.2			; 拉低SRCLK，准备输入数据
//		MOV		A, R4
//		RRC		A				; 行信号不断循环右移，对应LED灯高位到低位依次输进C
//		MOV		R4, A
//		MOV		P1.0, C			; 输出一行信号到端口
//		
//		MOV		A, R5	   		; 开始输入一个列信号
//		RRC		A
//		MOV		R5, A
//		MOV		P1.1, C
//		SETB	P1.2			; SRCLR上升沿锁存输入单个行信号和列信号
//		NOP						; 等待一拍，便于锁存稳定
//		DJNZ	R6, LATCH2		; 判断8位是否全部锁存
//		
//		SETB	P1.3			; RCLK上升沿，锁存器输出，LED亮一行
//
//		LCALL	DELAYLATCH
//
//		RET
//
//; 延时函数
//DELAYLATCH:	
//		MOV		R7, #0FFH	    
//LOOP:	MOV		R7, LOOP
//		RET			
//
//		
//		
//		ORG		1000H
//KEYTAB:	DB	0EEH,0DEH,0BEH,7EH,0EDH,0DDH,0BDH,7DH
//		DB	0EBH,0DBH,0BBH,7BH,0E7H,0D7H,0B7H,77H
//
//LED:	DB	0FCH,60H,0DAH,0F2H,66H,0B6H,0BEH,0E0H
//		DB	0FEH,0F6H,0EEH,3EH,9CH,7AH,9EH,8EH
//
//ROWTAB:	
//DB		80H,00H,40H,00H,20H,00H,10H,00H
//DB		08H,00H,04H,00H,02H,00H,01H,00H
//DB		00H,80H,00H,40H,00H,20H,00H,10H
//DB		00H,08H,00H,04H,00H,02H,00H,01H
//			
//		END
//
