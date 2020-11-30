`timescale 1ns / 1ps

module pipelineCPU_sim;

// Inputs 
reg clkin; 
reg reset; 

// Instantiate the Unit Under Test (UUT) 
PipelineCPU uut ( 
    .reset(reset),
    .clk(clkin)
); 

initial 
begin 
    // Initialize Inputs 
    clkin = 0; 
    reset = 0; 
    // Wait 20 ns for global reset to finish 
    #20; 
    reset = 1; 
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
