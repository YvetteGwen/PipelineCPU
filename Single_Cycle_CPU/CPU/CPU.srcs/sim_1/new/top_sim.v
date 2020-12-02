`timescale 1ns / 1ps

module top_sim;

// Inputs 
reg clkin; 
reg reset; 

wire[31:0] inst, pc, pcAdd4;

// Instantiate the Unit Under Test (UUT) 
top uut ( 
    .clkin(clkin), 
    .reset(reset),
    .inst(inst),
    .pc(pc),
    .pcAdd4(pcAdd4)
); 

initial 
begin 
    // Initialize Inputs 
    clkin = 0; 
    reset = 1; 
    // Wait 100 ns for global reset to finish 
    #20; 
    reset = 0; 
end 

parameter PERIOD = 20; 

always 
begin 
    clkin = 1'b0; 
    #(PERIOD / 2);
    clkin = 1'b1; 
    #(PERIOD / 2); 
end 
endmodule 
