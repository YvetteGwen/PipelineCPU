`timescale 1ns/1ps

module RegFile (
	reset, clk, addr1, data1,
	addr2, data2, wr, addr3, data3);

input reset,clk;
input wr; // write enable
input [4:0] addr1,addr2,addr3;
output [31:0] data1,data2;
input [31:0] data3;

reg [31:0] RF_data[31:0];

assign data1 = RF_data[addr1];
assign data2 = RF_data[addr2];

integer i;

always@(negedge reset or negedge clk) begin
	if(~reset) begin
		for(i = 0; i < 32; i = i + 1)  RF_data[i] <= 32'b0;
	end
	else begin
		// write enable == 1  &&  addr3 != 0 
		// $0 MUST be all zeros
		if(wr && (|addr3))
			RF_data[addr3] <= data3;
	end
end
endmodule
