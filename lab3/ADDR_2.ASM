//测量信号发生器产生不同频段方波的频率，并在通用RAM区显示10个结果。
	COUNT EQU 60H
	RESULT EQU 61H
	ORG 0000H
	LJMP MAIN

	ORG 0100H
MAIN:
	MOV TMOD,#05H ; T0 - Mode 1, T1 - Mode 0
	MOV TH0,#00H  ;T0计数,从0开始
	MOV TL0,#00H  ;
	MOV TH1,#4BH  ;T1定时,50ms
	MOV TL1,#0FDH
	MOV COUNT, #20 ;计时1s
	//MOV RESULT, #9 ;外面已经存了1个
	SETB TR0  ;T0计数启动，外接信号发生器
	SETB TR1  ;T1定时启动
	SETB P1.0
	MOV R0,#30H;存高8位
	MOV R1,#31H;存低8位
CON:
	JNB TF1, CON ;定时50ms后，溢出标志位=1往下执行，=0则继续计时
	CLR TF1;清除T1的溢出标志位
	DEC R2;计数次数减少
	MOV A,COUNT;把数值放进A用于判断
	JNZ CON;计数次数未达20次，继续计时
	CLR TR0;计数时间达到1s，停止计数
	MOV @R0,TH0;R0指向的地址里存高8位
	MOV @R1,TL0;R1指向的地址里存低8位

	SJMP $
	END