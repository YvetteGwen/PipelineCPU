`timescale 1ns / 1ps

module top( 
    input clk,//clk for display
    input clkin,//clkin for instruction
    input reset,
    input hi_lo,
    // output wire [31:0] inst,
    // output reg [31:0] pc,
    // output reg [31:0] pcAdd4
    output[3:0] sm_wei,
    output[6:0] seg
); 

// integer clk_cnt, clk_cnt_display;
// reg clkin, clkin_display;
// always @(posedge clk)
//     if(clk_cnt == 32'd50_000_000)
//     begin
//         clk_cnt <= 1'd0; 
//         clkin <= ~clkin;
//     end
//     else clk_cnt <= clk_cnt + 1'd1;

// always @(posedge clk)
//     if(clk_cnt_display == 32'd12_500_000)
//     begin
//         clk_cnt_display <= 1'd0;
//         clkin_display <= ~clkin_display;
//     end
//     else clk_cnt_display <= clk_cnt_display + 1'd1;

wire[31:0] inst;
reg [31:0] pc, pcAdd4;
// 指令寄存器pc 
wire pcWrite;
wire branchChoose, jumpChoose; 
wire[31:0] branchAddress, jumpAddress;

// 复用器信号线
wire[31:0] mux2, mux3, mux4, mux5, mux7, mux9; 
wire[4:0] mux1, mux6/*, mux8*/;

// CPU控制信号
wire regDst, ALUSrc, memRead, memWrite, memToReg, regWrite, jump, jal, jr, beq, bne, lui, extOption, mult, div, mfhi, mflo; 
wire[3:0] ALUOp; 

// ALUCtr、ALU信号
wire zero;
wire[31:0] ALURes, data_hi, data_lo;
wire[4:0] ALUCtr;

// 内存信号
wire[31:0] memReadData, memWriteData; 
wire[1:0] memFlag;

// 寄存器信号线
wire[31:0] RsData, RtData; 

// 扩展信号
wire[31:0] expand, expandShiftLeft2;

// 取指令
always @(negedge clkin) // 时钟下降沿操作
begin 
    if(!reset) 
    begin
        if(pcWrite)
        begin
            pc = mux7; // 计算下一条pc，修改pc 
            pcAdd4 = pc + 4;
        end
    end 
    else 
    begin
        pc = 32'b0; // 复位时pc=0
        pcAdd4 = 32'h4; 
    end 
end 

// 实例化控制器模块
controller mainctr( 
    .opCode(inst[31:26]),
    .funct(inst[5:0]),
    .ALUOp(ALUOp), 
    .regDst(regDst), 
    .ALUSrc(ALUSrc), 
    .memToReg(memToReg), 
    .memWrite(memWrite), 
    .memRead(memRead), 
    .regWrite(regWrite),
    .extOption(extOption),
    .beq(beq),
    .bne(bne),
    .jump(jump),
    .jal(jal),
    .jr(jr),
    .memFlag(memFlag),
    .pcWrite(pcWrite),
    .mult(mult),
    .div(div),
    .mfhi(mfhi),
    .mflo(mflo)
); 

// 实例化ALU模块
aluCtr aluctr( 
    .ALUOp(ALUOp),
    .funct(inst[5:0]), 
    .ALUCtr(ALUCtr)
); 

// 实例化寄存器模块
regFile regfile(
    .clk(!clkin),
    .reset(reset),
    .RsAddr(inst[25:21]), 
    .RtAddr(inst[20:16]), 
    .regWriteAddr(mux6), 
    .regWriteData(mux9), 
    .regWrite(regWrite), 
    .mult(mult),
    .div(div),
    .mfhi(mfhi),
    .mflo(mflo),
    .data_hi(data_hi),
    .data_lo(data_lo),
    .RsData(RsData), 
    .RtData(RtData)
); 

// 实例化ALU模块
ALU alu(
    .input1(RsData), 
    .input2(mux2), 
    .imm(inst[15:0]),
    .shamt(inst[10:6]),
    .ALUCtr(ALUCtr), 
    .zero(zero), 
    .ALURes(ALURes),
    .data_hi(data_hi),
    .data_lo(data_lo)
);

// 实例化DRAM模块
DRAM DMEM( 
    .clk(!clkin),
    .reset(reset),
    .addr(ALURes[7:0]), 
    .memRead(memRead),
    .memWrite(memWrite),
    .memFlag(memFlag),
    .memWriteData(RtData), 
    .memReadData(memReadData)
); 

// 实例化符号扩展模块
signext signext(
    .imm(inst[15:0]),
    .extOption(extOption), 
    .data(expand)
); 

IMEM imem(
    .clkin(clkin),
    .pc(pc),
    .inst(inst)
);

// 各个控制信号线，地址，符号扩展
assign mux1 = regDst ? inst[15:11] : inst[20:16]; 
assign mux2 = ALUSrc ? expand : RtData; 
assign mux3 = memToReg ? memReadData : ALURes; 
assign mux4 = branchChoose ? branchAddress : pcAdd4; 
assign mux5 = jumpChoose ? jumpAddress : mux4;
assign mux6 = jal ? 5'd31 : mux1;
assign mux7 = jr ? RsData : mux5;
assign mux9 = jal ? pcAdd4 : mux3;
assign branchChoose = (beq & zero) | (bne & (~zero)); 
assign jumpChoose = jump | jal;
assign expandShiftLeft2 = expand << 2; 
assign jumpAddress = {pcAdd4[31:28], inst[25:0], 2'b00}; 
assign branchAddress = pcAdd4 + expandShiftLeft2; 

display dis(
   .clk(clk),
   .data(ALURes),
   .hi_lo(hi_lo),
   .sm_wei(sm_wei),
   .sm_duan(seg)  
);

// display dis(
//    .clk(clkin_display),
//    .data(ALURes[15:0]),
//    .which(which),
//    .seg(seg)  
// );

endmodule 

