`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2019 10:11:49 PM
// Design Name: 
// Module Name: ALUCtr_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUCtr_sim;

// Inputs 
reg [2:0] ALUOp; 
reg [5:0] funct; 

// Outputs 
wire [4:0] ALUctr; 

// Instantiate the Unit Under Test (UUT) 
aluCtr uut ( 
    .ALUOp(ALUOp), 
    .funct(funct), 
    .ALUCtr(ALUctr) 
); 

initial 
    begin 
    // Initialize Inputs 
    ALUOp = 0; 
    funct = 0; 
    // Wait 100 ns for global reset to finish 
    #100; 
    // Add stimulus here 
    ALUOp = 3'b010; 
    funct = 0; 
    #100; 
    ALUOp = 3'b111; 
    funct = 6'b100011; 
    #100; 
    ALUOp = 3'b101; 
    funct = 6'b101010; 
end 
endmodule
