`timescale 1ns / 1ps

module shifter(
    input [31:0] SHIN,
    input [4:0]  AMT,
    input shDir,//1: right; 0 : left
    input Arith,//1 : arith; 0 : logical
    output reg [31:0] SHOUT
);

always @(*) 
begin
    if (!shDir)       SHOUT = SHIN << AMT ;
    else 
    begin
        if (!Arith)   SHOUT = SHIN >> AMT;
        else          SHOUT = $signed(SHIN) >>> AMT; //算数右移
    end
end	

endmodule
