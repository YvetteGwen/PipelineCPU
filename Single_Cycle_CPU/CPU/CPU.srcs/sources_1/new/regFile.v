`timescale 1ns / 1ps

module regFile( 
    input clk,                  //时钟信号
    input reset,                //复位信号
    input [4:0] RsAddr,	        //哪个寄存器作为 Rs寄存器 
    input [4:0] RtAddr,	        //哪个寄存器作为 Rt寄存器 
    input [4:0]  regWriteAddr,  //写寄存器时寄存器的地址（即写哪个寄存器） 
    input [31:0] regWriteData,  //写寄存器的值
    input regWrite,	            //写寄存器使能
    input mult,                 //mult标志
    input div,                  //div标志
    input mfhi,                 //读hi寄存器标志
    input mflo,                 //读lo寄存器标志
    input [31:0] data_hi,       //要写入hi寄存器的值
    input [31:0] data_lo,       //要写入lo寄存器的值
    output [31:0] RsData,       //Rs寄存器的值
    output [31:0] RtData        //Rt寄存器的值
);
//寄存器地址都是 5 位二进制数，
//寄存器有 32+2=34 个（加上hi、lo）
reg[31:0] regs[0:34];                 //寄存器组

//  根据地址读出 Rs、Rt 寄存器数据
assign RsData = (RsAddr == 5'b0) ? 32'b0 : regs[RsAddr]; 
assign RtData = (RtAddr == 5'b0) ? 32'b0 : regs[RtAddr]; 

integer i;

always @( posedge clk )               //时钟上升沿操作
begin
    if(!reset) 
    begin
        if(regWrite == 1)             //写使能信号为 1 时写操作
        begin
            if(mult == 1  || div == 1)//乘除法，写入hi、lo寄存器
            begin
                regs[32] = data_hi;
                regs[33] = data_lo;
            end
            else if(mfhi) regs[regWriteAddr] = regs[32];//mfhi
            else if(mflo) regs[regWriteAddr] = regs[33];//mflo
            else regs[regWriteAddr] = regWriteData;     //写入数据
        end
            
    end 
    else 
    begin
        for(i = 0; i <= 34; i = i + 1) regs[i] = 0; //重置时所有寄存器赋值为 0，复位 
    end
end

endmodule



