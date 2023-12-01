/*
1.分别用STC15的定时器/计数器T0，模式0及查询方式，
定时器/计数器T1，模式1及中断方式，产生方波信号，
频率为近似自己的座位号即：4kHz，且程序中无口地址。
*/
	//查询方式
	ORG 0000H
	LJMP MAIN

	ORG 0100H
MAIN:
	AUXR2 EQU 8FH
	MOV TMOD, #00H	    ; 模式0，16位自动重载
	ORL AUXR2, #01H     ;T1(P3.5)示波器看数据
	MOV TH0,#0FFH		; 设置高字节计数初值
	MOV TL0,#8DH		; 设置低字节计数初值
	SETB P1.0			; 示波器测量端口
	SETB TR0			; 开启T0定时器
	
LOOP:
	JNB TF0, LOOP		; 定时器T0未溢出，继续循环查询
	//CPL P1.0			; 溢出后翻转P1.0
	CLR TF0				; 溢出标志位归零
	SJMP LOOP			; 循环查询
	SJMP $
	END




	//中断方式
	ORG 0000H
	LJMP MAIN
	ORG 001BH			  ; 中断服务程序入口地址
    LJMP INTT1			  ; 跳转至中断服务程序

	ORG 0100H
MAIN:
	MOV SP, #60H		; 设置堆栈区域
	MOV TMOD, #10H		; 设置T1为模式1：16位定时器，工作方式1
	MOV TH1,#0FFH		; 设置高字节计数初值
	MOV TL1,#8DH		; 设置低字节计数初值
	SETB P1.0			; 示波器测量端口

	SETB EA				; 允许中断
	SETB ET1			; 允许定时器T1中断

	SETB TR1			; 开启T1定时器
   	SJMP $

	ORG 0200H 
INTT1:
	//CLR TF1 			; 清除定时器T1中断标志
	PUSH ACC
	PUSH DPL
	PUSH DPH
	MOV TH1,#0FAH		; 设置高字节计数初值
	MOV TL1,#9AH		; 设置低字节计数初值
	CPL P1.0
	POP DPH
	POP DPL
	POP ACC
	RETI

	END