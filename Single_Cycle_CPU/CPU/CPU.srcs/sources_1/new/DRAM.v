`timescale 1ns / 1ps

module DRAM(
    input clk,                  //时钟信号
    input reset,                //复位信号
    input [7:0] addr,           //地址信号
    input memRead,              //memory读使能信号
    input memWrite,             //memory写使能信号
    input [1:0] memFlag,        //00-> byte 01->half word  11->word
    input [31:0] memWriteData,  //要写入memory的信号
    output [31:0] memReadData   //从memory读取的信号
);
			 	 
reg[7:0] RAM[255:0]; 

//read
assign memReadData = memRead ? ( memFlag[1] ? { {RAM[addr]}, {RAM[addr+1]}, {RAM[addr+2]}, {RAM[addr+3]}} : ( memFlag[0] ? { {16{RAM[addr][7]}}, {RAM[addr]} , {RAM[addr+1]} } : { {24{RAM[addr][7]}}, RAM[addr]} ) ) : 32'b0;

//write flag作为字节或字半字操作的标志
integer i;

always @ (posedge clk, posedge reset)
begin
    if(reset)
    begin
        for(i = 0; i < 256; i = i + 1) 
            RAM[i]=0;       
    end	
    else if (memWrite) 
    begin
        if(memFlag == 2'b00)
        begin
            RAM[addr] = memWriteData[7:0];
        end
        else if(memFlag == 2'b01)
        begin
            { {RAM[addr]}, {RAM[addr+1]} } = memWriteData[15:0];
        end
        else if(memFlag == 2'b11)
        begin
            { {RAM[addr]}, {RAM[addr+1]}, {RAM[addr+2]}, {RAM[addr+3]}} = memWriteData[31:0];
        end           
    end  
end
    
endmodule

