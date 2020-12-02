`timescale 1ns / 1ps

// ALUOp = 4'b0000; 

module controller(
    input [5:0] opCode,         //指令的opCode段
    input [5:0] funct,          //指令的funct段
    output reg [3:0] ALUOp,     //ALUOp信号，用于结合funct控制ALUCtr信号
    output reg regDst,          //1：使用rd寄存器；0：使用rt寄存器
    output reg ALUSrc,          //1：存在立即数；0：不存在立即数
    output reg memToReg,        //1：从DataMemory向寄存器写入数据
    output reg memWrite,        //1：写DataMemory使能信号
    output reg memRead,         //1：读DataMemory使能信号
    output reg regWrite,        //1：写寄存器使能信号
    output reg extOption,       //1：符号扩展；0：0扩展
    output reg beq,             //beq指令标志
    output reg bne,             //bne指令标志
    output reg jump,            //j指令标志
    output reg jal,             //jal指令标志
    output reg jr,              //jr指令标志
    output reg[1:0] memFlag,    //11:word; 01: half word; 00: byte
    output pcWrite,             //写pc使能信号
    output reg mult,            //mult指令标志
    output reg div,             //div指令标志
    output reg mfhi,            //mfhi指令标志
    output reg mflo             //mflo指令标志
);

assign pcWrite = (opCode == 6'b111111) ? 0 : 1;

always @(opCode,funct) 
begin
    case(opCode)
        6'b000000: // R型指令
        begin
            ALUOp = 4'b0111;
            regDst = 1;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;             
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;

            if(funct==6'b001000)  jr = 1;  //jr
            else if(funct==6'b011000) // mult
                    mult = 1;
            else if(funct==6'b011010) //div
                    div = 1;
            else if(funct==6'b010000) //mfhi
                    mfhi = 1;
            else if(funct==6'b010010) //mflo
                    mflo = 1;
        end
        6'b001000: // addi指令
        begin
            ALUOp = 4'b0000;
            regDst = 0;    
            ALUSrc = 1;
            memToReg = 0;  
            memRead = 0;   
            memWrite = 0; 
            regWrite = 1;
            extOption = 1; 
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;      
        end
        6'b001001: // addiu指令
        begin
            ALUOp = 4'b0000;
            regDst = 0;    
            ALUSrc = 1;
            memToReg = 0;  
            memRead = 0;   
            memWrite = 0; 
            regWrite = 1;
            extOption = 1; 
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;    
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end
        6'b001100: // andi指令
        begin
            ALUOp = 4'b0010;
            regDst = 0;
            ALUSrc = 1; 
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 0;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;      
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end   
    6'b001101: // ori指令
        begin
            ALUOp = 4'b0011;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 0;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end              
        6'b001110: // xori指令
        begin
            ALUOp = 4'b0100;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 0;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;    
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end 
        6'b001111:    //lui
        begin
            ALUOp = 4'b0110;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;   
            memFlag <= 2'b11;  
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0; 
        end    
        6'b100011: // lw
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 1;
            memRead = 1;
            memWrite = 0;
            regWrite = 1; 
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;   
            memFlag <= 2'b11;  
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end
        6'b100001: // lh
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 1;
            memRead = 1;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b01;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end   
        6'b100000: // lb
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 1;
            memRead = 1;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;   
            memFlag <= 2'b00;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end              
        6'b101011: // sw
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 1;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;  
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end
        6'b101001: // sh
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 1;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b01;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end    
        6'b101000: // sb
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 1;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b00;       
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end             
        6'b000100: //beq指令
        begin
            ALUOp = 4'b0001;
            regDst = 0;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            extOption = 1;
            beq = 1;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;     
        end
        6'b000101: //bne指令
        begin
            ALUOp = 4'b0001;
            regDst = 0;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 1;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;  
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;      
        end  
        6'b001010: // slti指令
        begin
            ALUOp = 4'b0101;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;  
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;      
        end            
        6'b001011: //sltiu
        begin
            ALUOp = 4'b0101;
            regDst = 0;
            ALUSrc = 1;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;      
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;  
        end      
        6'b000010: // jump
        begin 
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 1;
            jal = 0;
            jr = 0;
            memFlag <= 2'b11;         
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end
        6'b000011: // jal
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 1;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 1;
            jr = 0; 
            memFlag <= 2'b11;      
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0; 
        end        
        default: // 缺省值
        begin
            ALUOp = 4'b0000;
            regDst = 0;
            ALUSrc = 0;
            memToReg = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            extOption = 1;
            beq = 0;
            bne = 0;
            jump = 0;
            jal = 0;
            jr = 0;
            mult = 0;
            div = 0;
            mfhi = 0;
            mflo = 0;
        end
    endcase
end
endmodule