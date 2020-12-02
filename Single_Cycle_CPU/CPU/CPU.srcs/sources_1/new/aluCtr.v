`timescale 1ns / 1ps

module aluCtr(
    input [3:0] ALUOp,
    input [5:0] funct,
    output reg [4:0] ALUCtr
);

always @(ALUOp or funct)  
    casex({ALUOp, funct}) 
        //非R型
        10'b0000xxxxxx: ALUCtr = 5'b00000; // add : lw, lh, lb, sw, sh, sb, addi
        10'b0001xxxxxx: ALUCtr = 5'b00010; // sub : beq, bne
        10'b0010xxxxxx: ALUCtr = 5'b00100; // and : andi
        10'b0011xxxxxx: ALUCtr = 5'b00101; // or : ori
        10'b0100xxxxxx: ALUCtr = 5'b00110; // xor : xori
        10'b0101xxxxxx: ALUCtr = 5'b01001; // slt : slti, sltiu
        10'b0110xxxxxx: ALUCtr = 5'b01010; // lui

        //R型  ALUOp = 111
        10'b0111_100000: ALUCtr = 5'b00000; // add
        10'b0111_100001: ALUCtr = 5'b00001; // addu
        10'b0111_100010: ALUCtr = 5'b00010; // sub
        10'b0111_100011: ALUCtr = 5'b00011; // subu
        10'b0111_100100: ALUCtr = 5'b00100; // and
        10'b0111_100101: ALUCtr = 5'b00101; // or
        10'b0111_100110: ALUCtr = 5'b00110; // xor
        10'b0111_100111: ALUCtr = 5'b00111; // nor
        10'b0111_101010: ALUCtr = 5'b01000; // slt
        10'b0111_101011: ALUCtr = 5'b01001; // sltu

        10'b0111_000000: ALUCtr = 5'b01011; // sll
        10'b0111_000010: ALUCtr = 5'b01100; // srl
        10'b0111_000011: ALUCtr = 5'b01101; // sra
        10'b0111_000100: ALUCtr = 5'b01111; // sllv
        10'b0111_000110: ALUCtr = 5'b10000; // srlv
        10'b0111_000111: ALUCtr = 5'b10001; // srav       
        10'b0111_011000: ALUCtr = 5'b10010; // mult
        10'b0111_011010: ALUCtr = 5'b10011; // div
        
        default: ALUCtr = 5'b00000;
    endcase
    
endmodule


