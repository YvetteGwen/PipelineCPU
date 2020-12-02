module Forward_Unit(IF_ID_Rs, ID_EX_Rs, ID_EX_Rt, ID_PCSrc, ID_EX_RegWrite, ID_EX_AddrC, EX_MEM_RegWrite, EX_MEM_AddrC,
	MEM_WB_RegWrite, MEM_WB_AddrC, ForwardA, ForwardB);
	
input [4:0] IF_ID_Rs;
input [4:0] ID_EX_Rs;
input [4:0] ID_EX_Rt;
input [2:0] ID_PCSrc;
input ID_EX_RegWrite;
input [4:0] ID_EX_AddrC;
input EX_MEM_RegWrite;
input [4:0] EX_MEM_AddrC;
input MEM_WB_RegWrite;
input [4:0] MEM_WB_AddrC;

output reg [1:0] ForwardA;
output reg [1:0] ForwardB;

always @(*) begin
	if(EX_MEM_RegWrite && EX_MEM_AddrC != 5'h00
		&& EX_MEM_AddrC == ID_EX_Rs) begin
		ForwardA = 2'b10;
	end
	else if(MEM_WB_RegWrite && MEM_WB_AddrC != 5'h00
		&& MEM_WB_AddrC == ID_EX_Rs) begin
		ForwardA = 2'b01;
	end
	else 
		ForwardA = 2'b00;
	
	// Only replace Rt with Rs for ForwardA
	if(EX_MEM_RegWrite && EX_MEM_AddrC != 5'h00
		&& EX_MEM_AddrC == ID_EX_Rt) begin
		ForwardB = 2'b10;
	end
	else if(MEM_WB_RegWrite && MEM_WB_AddrC != 5'h00
		&& MEM_WB_AddrC == ID_EX_Rt) begin
		ForwardB = 2'b01;
	end
	else 
		ForwardB = 2'b00;
		
end

endmodule