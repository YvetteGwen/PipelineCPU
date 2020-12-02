`timescale 1ns / 1ps

module signext( 
    input [15:0] imm,  // 16 bits input
    input extOption,    // 1: signextend; 0: zeroextend
    output [31:0] data  // 32 bits output
); 

// 根据符号补充符号位
// 如果符号位为1，则补充16个1，即16’h ffff 
// 如果符号位为0，则补充16个0 
assign data = (extOption & imm[15:15]) ? {16'hffff,imm} : {16'h0000,imm}; 

endmodule 
