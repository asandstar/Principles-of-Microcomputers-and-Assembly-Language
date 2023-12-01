	SCLA EQU P1.0
	SDAA EQU P1.1
	LOAD EQU P1.2
	LDAC EQU P1.3
	ORG 0000H
	LJMP MAIN
	ORG 0100H
MAIN:
	MOV SP,#60H
	SETB SCLA	;时钟端默认高电平
	SETB SDAA	;先输出ref=2.5V参考电压
	SETB LOAD	;先拉高锁存数据口的电平
	SETB LDAC	;拉高控制DAC电平
	MOV R1,#11100000B ;A1A0=11，输出位DACD，RNG=1
	MOV R2, #00001010B
	LCALL DAC5620
	SJMP MAIN
	
	SJMP $

DAC5620:	
	MOV	A,R1		;R1为控制字节
	CLR	SCLA		;清零时钟端
	MOV	R7,#03H		;设置循环次数，3bist
	LCALL SENDBYTE	;调用送数子程序，发送控制字
	MOV	A,R2		;R2为待转换数据
	CLR	SCLA		;清零时钟端
	MOV	R7,#08H		;设置循环次数，8bit
	LCALL SENDBYTE	;调用送数子程序，发送数字数据
	CLR	LOAD		;锁存数据
	SETB LOAD
	CLR	LDAC		;更新DAC输出
	SETB LDAC
	RET

SENDBYTE:	
	SETB SCLA		 ;置位时钟端
	RLC	A		 ;循环移位1位数据
	MOV	SDAA,C		 ;数据移入寄存器
	CLR	SCLA		 ;产生时钟下降沿，读入数据
	DJNZ R7,SENDBYTE	 ;循环
	RET
	
	END
