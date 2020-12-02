`timescale 1ns / 1ps

module ALU(
    input [31:0] input1,        //操作数，32位，输入
    input [31:0] input2,        //操作数，32位，输入
    input [15:0] imm,           //lui指令的立即数
    input [4:0] ALUCtr,         //ALUCtr，5位操作码，输入
    input [4:0] shamt,          //shift的移动距离shamt
    output reg[31:0] ALURes,    //运算结果，32位，输出
    output reg[31:0] data_hi,   //要写入hi寄存器的数据
    output reg[31:0] data_lo,   //要写入lo寄存器的数据
    output reg zero             //零标志，1位；当运算结果为0时，该位为1，否则为0
); 

/*
+     00000
+u    00001
-     00010
-u    00011
and   00100
or    00101
xor   00110
nor   00111
slt   01000
sltu  01001
lui   01010
sll   01011
srl   01100
sra   01101
sllv  01111
srlv  10000
srav  10001
*/


always @(input1 or input2 or ALUCtr) // 运算数或控制码变化时操作
begin 
    case(ALUCtr) 
    5'b00000: // +
    begin
        ALURes = $signed(input1) + $signed(input2);
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b00001: // +u
    begin
        ALURes = input1 + input2;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b00010: // -
    begin 
        ALURes = $signed(input1) - $signed(input2); 
        if(ALURes == 0) zero = 1; 
        else zero = 0; 
        data_hi = 0;
        data_lo = 0;
    end 
    5'b00011: // -u
        begin 
            ALURes = input1 - input2; 
            if(ALURes == 0) zero = 1; 
            else zero = 0; 
            data_hi = 0;
            data_lo = 0;
        end 
    5'b00100: // and
    begin
        ALURes = input1 & input2; 
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b00101: // or
    begin
        ALURes = input1 | input2; 
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b00110: // xor
    begin
        ALURes = ((~input1) & input2) | (input1 & (~input2));
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b00111: // nor
    begin
        ALURes = ~(input1 | input2);
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b01000: // slt
    begin 
        if($signed(input1) < $signed(input2)) ALURes = 1; 
        else ALURes = 0;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end 
    5'b01001: // sltu
    begin 
        if(input1 < input2) ALURes = 1; 
        else ALURes = 0;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end 
    5'b01010: // lui
    begin
        ALURes = {imm[15:0], 16'h0000};
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b01011: //sll
    begin
        ALURes = input2 << shamt;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b01100: //srl
    begin
        ALURes = input2 >> shamt;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b01101: //sra
    begin
        ALURes = $signed(input2) >>> shamt;
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b01111: //sllv
    begin
        ALURes = input2 << input1[4:0];
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b10000: //srlv
    begin
        ALURes = input2 >> input1[4:0];
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b10001: //srav
    begin
        ALURes = $signed(input2) >>> input1[4:0];
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    5'b10010: //mult
    begin
        {data_hi, data_lo} = input1 * input2;
        ALURes = 0;
        zero = 0; 
    end
    5'b10011: //div
    begin
        data_hi = input1 / input2;
        data_lo = input1 % input2;
        ALURes = 0;
        zero = 0;
    end
    default: 
    begin
        ALURes = 0; 
        zero = 0;
        data_hi = 0;
        data_lo = 0;
    end
    endcase 
end 

endmodule 

