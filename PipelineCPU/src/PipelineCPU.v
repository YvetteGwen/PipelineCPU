module PipelineCPU(clk, reset);

input clk;
input reset;

//IF
wire [2:0] IF_PCSrc;
reg [31:0] IF_PC;
wire [31:0] IF_PC_add;
wire [31:0] IF_PC_add_4;
wire [31:0] IF_Instruct;

//ID
wire [31:0]	ID_PC_add_4;
wire [31:0] ID_Instruct;
wire [4:0] ID_Rs;
wire [4:0] ID_Rt;
wire [4:0] ID_Rd;
wire [4:0] ID_Shamt;
wire [15:0] ID_Immediate;
wire [25:0] ID_JumpAddr;
wire [31:0] ID_JT;//jump target
wire [31:0] ID_DataBusA;
wire [31:0] ID_DataBusB;
wire [31:0] ID_EXTOut;
wire [31:0] ID_LUOut;

wire [1:0] ID_RegDst;
wire [2:0] ID_PCSrc;
wire ID_MemRead;
wire ID_MemWrite;
wire [1:0] ID_MemToReg;
wire [5:0] ID_ALUFun;
wire ID_EXTOp;
wire ID_LUOp;
wire ID_ALUSrc1;
wire ID_ALUSrc2;
wire ID_RegWrite;
wire ID_Sign;

//EX
wire [31:0]	EX_PC_add_4;
wire [4:0] EX_Rs;
wire [4:0] EX_Rt;
wire [4:0] EX_Rd;
wire [4:0] EX_Shamt;
wire [4:0] EX_AddrC;
wire [31:0]	EX_ALU_A;
wire [31:0]	EX_ALU_B;
wire [31:0] EX_ALUOut;
wire [31:0] EX_DataBusA;
wire [31:0] EX_DataBusB;
wire [31:0] EX_LUOut;
wire [31:0] EX_BT;

wire EX_Sign;
wire [1:0] EX_RegDst;
wire [2:0] EX_PCSrc;
wire EX_MemRead;
wire EX_MemWrite;
wire [1:0] EX_MemToReg;
wire [5:0] EX_ALUFun;
wire EX_ALUSrc1;
wire EX_ALUSrc2;
wire EX_RegWrite;

//MEM
wire [31:0] MEM_PC_add_4;
wire [4:0] MEM_Rt;
wire [4:0] MEM_Rd;
wire [31:0] MEM_DataBusB;
wire [4:0] MEM_AddrC;
wire [31:0] MEM_MemReadData;
wire [31:0] MEM_ALUOut;

wire [1:0] MEM_RegDst;
wire MEM_MemRead;
wire MEM_MemWrite;
wire [1:0] MEM_MemToReg;
wire MEM_RegWrite;

//WB
wire [31:0] WB_PC_add_4;
wire [4:0] WB_Rt;
wire [4:0] WB_Rd;
wire [31:0] WB_DataBusC;
wire [31:0] WB_MemReadData;
wire [4:0] WB_AddrC;
wire [31:0] WB_ALUOut;

wire [1:0] WB_RegDst;
wire [1:0] WB_MemToReg;
wire WB_RegWrite;

//Data Memory
wire [31:0] DataMem_ReadData;
wire [31:0] DataMem_MemAddr;
wire [31:0] DataMem_WriteData;
wire DataMem_MemWrite;
wire DataMem_MemRead;

//Forward
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] ForwardAData;
wire [31:0] ForwardBData;
wire [31:0] ForwardJData;

//Hazard
wire PCWrite;
wire IF_ID_write;
wire IF_ID_flush;
wire ID_EX_flush;

assign IF_PCSrc = (EX_PCSrc == 3'b001 && EX_ALUOut[0]) ? 3'b001 : (ID_PCSrc == 3'b001 ? 3'b000 : ID_PCSrc);

assign IF_PC_add = IF_PC + 32'h4;
assign IF_PC_add_4 = {IF_PC[31], IF_PC_add[30:0]};

always@(posedge clk or negedge reset) 
	if(~reset)
		IF_PC <= 32'h0000_0000;			//PC begins at 0x0000_0000
	else if(PCWrite)
		case(IF_PCSrc)
			3'h0: IF_PC <= IF_PC_add_4;	//pc+4
			3'h1: IF_PC <= EX_BT;		//branch target
			3'h2: IF_PC <= ID_JT;		//jump target
			3'h3: IF_PC <= ForwardJData;//jump register
			default: IF_PC <= 32'h0000_0000;
		endcase

ROM ROM(.addr(IF_PC), .data(IF_Instruct));

IF_ID_Reg IF_ID_Reg(
	.clk(clk), .reset(reset),	.IF_ID_flush(IF_ID_flush), 
	.ID_EX_flush(ID_EX_flush), 	.IF_ID_write(IF_ID_write), 
	.PC_add_4_in(IF_PC_add_4), 	.Instruct_in(IF_Instruct), 
	.PC_add_4_out(ID_PC_add_4), .Instruct_out(ID_Instruct));

assign ID_Rs = ID_Instruct[25:21];
assign ID_Rt = ID_Instruct[20:16];
assign ID_Rd = ID_Instruct[15:11];
assign ID_Shamt = ID_Instruct[10:6];
assign ID_Immediate = ID_Instruct[15:0];
assign ID_JumpAddr = ID_Instruct[25:0];

assign WB_DataBusC = (WB_MemToReg == 2'b00)? WB_ALUOut: (WB_MemToReg == 2'b01)? WB_MemReadData: WB_PC_add_4;

RegFile RegFile(
	.reset(reset), .clk(clk), 
	.addr1(ID_Rs), .data1(ID_DataBusA), 
	.addr2(ID_Rt), .data2(ID_DataBusB), 
	.wr(WB_RegWrite),
	.addr3(WB_AddrC), .data3(WB_DataBusC));

//ID_EXTOp = 1 : sign extend; 0 : zero extend
assign ID_EXTOut = {ID_EXTOp? {16{ID_Immediate[15]}}: 16'h0000, ID_Immediate[15:0]};
//ID_LUOp = 1 : lui; 0 : else
//ID_LUOut = lui data
assign ID_LUOut = ID_LUOp? {ID_Immediate[15:0], 16'h0000}: ID_EXTOut;
//jump target
assign ID_JT = {IF_PC_add_4[31:28], ID_JumpAddr, 2'b00};	

ID_EX_Reg ID_EX_Reg(
	.clk(clk), .reset(reset),	.ID_EX_flush(ID_EX_flush), 
	.PC_add_4_in(ID_PC_add_4),	.DataBusA_in(ID_DataBusA), 
	.DataBusB_in(ID_DataBusB),	.LUOut_in(ID_LUOut), 
	.Rs_in(ID_Rs),				.Rt_in(ID_Rt), 
	.Rd_in(ID_Rd), 				.Shamt_in(ID_Shamt),
	.RegDst_in(ID_RegDst), 		.PCSrc_in(ID_PCSrc),
	.MemRead_in(ID_MemRead), 	.MemWrite_in(ID_MemWrite),	
	.MemToReg_in(ID_MemToReg), 	.ALUFun_in(ID_ALUFun),
	.ALUSrc1_in(ID_ALUSrc1), 	.ALUSrc2_in(ID_ALUSrc2),
	.RegWrite_in(ID_RegWrite), 	.Sign_in(ID_Sign),
	.PC_add_4_out(EX_PC_add_4), .DataBusA_out(EX_DataBusA), 
	.DataBusB_out(EX_DataBusB), .LUOut_out(EX_LUOut),
	.Rs_out(EX_Rs), 			.Rt_out(EX_Rt), 
	.Rd_out(EX_Rd), 			.Shamt_out(EX_Shamt), 
	.RegDst_out(EX_RegDst), 	.PCSrc_out(EX_PCSrc), 
	.MemRead_out(EX_MemRead), 	.MemWrite_out(EX_MemWrite), 
	.MemToReg_out(EX_MemToReg), .ALUFun_out(EX_ALUFun), 
	.ALUSrc1_out(EX_ALUSrc1), 	.ALUSrc2_out(EX_ALUSrc2), 
	.RegWrite_out(EX_RegWrite), .Sign_out(EX_Sign));
	
// ALU Input 
assign EX_ALU_A = EX_ALUSrc1? {17'h00000, EX_Shamt}: ForwardAData;
assign EX_ALU_B = EX_ALUSrc2? EX_LUOut: ForwardBData;	
// Jump dst for branch instruction
assign EX_BT = (EX_ALUOut[0])? EX_PC_add_4 + {EX_LUOut[29:0], 2'b00}: EX_PC_add_4;
// AddrC will be used in WB, so it will flow to the next state
assign EX_AddrC = (EX_RegDst == 2'b00)? EX_Rd: (EX_RegDst == 2'b01)? EX_Rt: 5'd31;	
	
ALU	ALU(
	.A(EX_ALU_A),		.B(EX_ALU_B), 
	.ALUFun(EX_ALUFun), .Sign(EX_Sign), 
	.Z(EX_ALUOut));

EX_MEM_Reg EX_MEM_Reg(
	.clk(clk), 					.reset(reset), 
	.PC_add_4_in(EX_PC_add_4), 	.ALUOut_in(EX_ALUOut), 
	.DataBusB_in(ForwardBData), .Rt_in(EX_Rt), 
	.Rd_in(EX_Rd), 				.RegDst_in(EX_RegDst), 
	.MemRead_in(EX_MemRead), 	.MemWrite_in(EX_MemWrite), 
	.MemToReg_in(EX_MemToReg), 	.RegWrite_in(EX_RegWrite), 
	.AddrC_in(EX_AddrC),		.PC_add_4_out(MEM_PC_add_4), 
	.ALUOut_out(MEM_ALUOut), 	.DataBusB_out(MEM_DataBusB), 
	.Rt_out(MEM_Rt), 			.Rd_out(MEM_Rd), 
	.RegDst_out(MEM_RegDst), 	.MemRead_out(MEM_MemRead), 
	.MemWrite_out(MEM_MemWrite),.MemToReg_out(MEM_MemToReg), 
	.RegWrite_out(MEM_RegWrite),.AddrC_out(MEM_AddrC));

assign DataMem_MemAddr = MEM_ALUOut;
assign DataMem_MemWrite = MEM_MemWrite;
assign DataMem_MemRead = MEM_MemRead;
assign MEM_MemReadData = DataMem_ReadData;
assign DataMem_WriteData = MEM_DataBusB;

MEM_WB_Reg MEM_WB_Reg(
	.clk(clk), .reset(reset), 		.PC_add_4_in(MEM_PC_add_4), 
	.ALUOut_in(MEM_ALUOut), 		.MemReadData_in(MEM_MemReadData), 
	.Rt_in(MEM_Rt),					.Rd_in(MEM_Rd), 
	.RegDst_in(MEM_RegDst), 		.MemToReg_in(MEM_MemToReg), 
	.RegWrite_in(MEM_RegWrite), 	.AddrC_in(MEM_AddrC), 
	.PC_add_4_out(WB_PC_add_4), 	.ALUOut_out(WB_ALUOut), 
	.MemReadData_out(WB_MemReadData), .Rt_out(WB_Rt), 
	.Rd_out(WB_Rd), 				.RegDst_out(WB_RegDst), 
	.MemToReg_out(WB_MemToReg), 	.RegWrite_out(WB_RegWrite), 
	.AddrC_out(WB_AddrC));

Control Control(
	.Instruct(ID_Instruct),			.PCSrc(ID_PCSrc),
	.RegWr(ID_RegWrite), 			.RegDst(ID_RegDst),
	.MemRd(ID_MemRead), 			.MemWr(ID_MemWrite),
	.MemToReg(ID_MemToReg), 		.ALUSrc1(ID_ALUSrc1),
	.ALUSrc2(ID_ALUSrc2), 			.EXTOp(ID_EXTOp), 
	.LUOp(ID_LUOp), 				.ALUFun(ID_ALUFun), 
	.Sign(ID_Sign));

DataMem DataMem(
	.reset(reset), 				.clk(clk), 
	.rd(DataMem_MemRead), 		.wr(DataMem_MemWrite), 
	.addr(DataMem_MemAddr), 	.wdata(DataMem_WriteData), 
	.rdata(DataMem_ReadData));

Forward_Unit Forward_Unit(
	.IF_ID_Rs(ID_Rs), 				.ID_EX_Rs(EX_Rs), 
	.ID_EX_Rt(EX_Rt), 				.ID_PCSrc(ID_PCSrc), 
	.ID_EX_RegWrite(EX_RegWrite), 	.ID_EX_AddrC(EX_AddrC),
	.EX_MEM_RegWrite(MEM_RegWrite), .EX_MEM_AddrC(MEM_AddrC), 
	.MEM_WB_RegWrite(WB_RegWrite), 	.MEM_WB_AddrC(WB_AddrC), 
	.ForwardA(ForwardA), 			.ForwardB(ForwardB));

assign ForwardAData = (ForwardA==2'b00) ? EX_DataBusA : (ForwardA==2'b01) ? WB_DataBusC : MEM_ALUOut;
assign ForwardBData = (ForwardB==2'b00) ? EX_DataBusB : (ForwardB==2'b01) ? WB_DataBusC : MEM_ALUOut;

Hazard_Unit Hazard_Unit(
	.IF_ID_Rs(ID_Rs), 			.IF_ID_Rt(ID_Rt), 
	.ID_PCSrc(ID_PCSrc),		.EX_PCSrc(EX_PCSrc), 
	.ID_EX_MemRead(EX_MemRead), .ID_EX_Rt(EX_Rt), 
	.EX_ALUOut_0(EX_ALUOut[0]), .PCWrite(PCWrite), 
	.IF_ID_write(IF_ID_write),	.IF_ID_flush(IF_ID_flush), 
	.ID_EX_flush(ID_EX_flush));

endmodule
