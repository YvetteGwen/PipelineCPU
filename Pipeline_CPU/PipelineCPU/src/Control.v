module Control(Instruct, PCSrc, RegWr, RegDst, MemRd, MemWr, MemToReg, ALUSrc1, ALUSrc2, EXTOp, LUOp, ALUFun, Sign);
input [31:0] Instruct; 
output reg [2:0] PCSrc;
output reg RegWr;
output reg [1:0] RegDst;
output reg MemRd;
output reg MemWr;
output reg [1:0] MemToReg;
output reg ALUSrc1;
output reg ALUSrc2;
output reg EXTOp;
output reg LUOp;
output reg [5:0] ALUFun;
output reg Sign;

always @(*) begin
	case(Instruct[31:26])
		6'b10_0011: begin	//lw
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 1;
			MemWr = 0;
			MemToReg = 2'd1;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b10_1011: begin	//sw
			PCSrc = 3'd0;
			RegWr = 0;
			RegDst = 2'd0;
			MemRd = 0;
			MemWr = 1;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end			
		6'b00_1111: begin	//lui
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 1;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b011110;
			Sign = 1;
			EXTOp = 1;
			LUOp = 1;
		end
		6'b00_1000: begin	//addi
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_1001: begin	//addiu
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_1100: begin	//andi
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b011000;
			Sign = 1;
			EXTOp = 0;
			LUOp = 0;
		end
		
		6'b00_1101: begin	//ori
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b011110;
			Sign = 1;
			EXTOp = 0;
			LUOp = 0;
		end
		
		6'b00_1010: begin	//slti
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b110101;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_1011: begin	//sltiu
			PCSrc = 3'd0;
			RegWr = 1;
			RegDst = 2'd1;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 1;
			ALUFun = 6'b110101;
			Sign = 0;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_0100: begin	//beq
			PCSrc = 3'd1;
			RegWr = 0;
			RegDst = 2'd0;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 0;
			ALUFun = 6'b110011;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_0101: begin	//bne
			PCSrc = 3'd1;
			RegWr = 0;
			RegDst = 2'd0;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 0;
			ALUFun = 6'b110001;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_0010: begin	//j
			PCSrc = 3'd2;
			RegWr = 0;
			RegDst = 2'd0;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 0;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_0011: begin	//jal
			PCSrc = 3'd2;
			RegWr = 1;
			RegDst = 2'd2;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd2;
			ALUSrc1 = 0;
			ALUSrc2 = 0;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
		6'b00_0000: begin	//R型 0x00
			case(Instruct[5:0])
				6'b10_0000: begin	//add
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0001: begin	//addu
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0010: begin	//sub
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000001;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0011: begin	//subu
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000001;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0100: begin	//and
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b011000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0101: begin	//or
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b011110;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0110: begin	//xor
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b010110;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_0111: begin	//nor
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b010001;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b00_0000: begin	//sll
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 1;
					ALUSrc2 = 0;
					ALUFun = 6'b100000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b00_0010: begin	//srl
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 1;
					ALUSrc2 = 0;
					ALUFun = 6'b100001;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b00_0011: begin	//sra
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 1;
					ALUSrc2 = 0;
					ALUFun = 6'b100011;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_1010: begin	//slt
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b110101;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b10_1011: begin	//sltu
					PCSrc = 3'd0;
					RegWr = 1;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b110101;
					Sign = 0;
					EXTOp = 1;
					LUOp = 0;
				end
				6'b00_1000: begin	//jr
					PCSrc = 3'd3;
					RegWr = 0;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;
				end
				default: begin
					PCSrc = 3'd0;
					RegWr = 0;
					RegDst = 2'd0;
					MemRd = 0;
					MemWr = 0;
					MemToReg = 2'd0;
					ALUSrc1 = 0;
					ALUSrc2 = 0;
					ALUFun = 6'b000000;
					Sign = 1;
					EXTOp = 1;
					LUOp = 0;						
				end
			endcase
		end
		default: begin
			RegWr = 0;
			RegDst = 2'd0;
			MemRd = 0;
			MemWr = 0;
			MemToReg = 2'd0;
			ALUSrc1 = 0;
			ALUSrc2 = 0;
			ALUFun = 6'b000000;
			Sign = 1;
			EXTOp = 1;
			LUOp = 0;
		end
	endcase
end

endmodule