`timescale 1ns / 1ps

module display(clk,data,hi_lo,sm_wei,sm_duan); 

input clk;
input [31:0] data;
input hi_lo;
output [3:0] sm_wei;
output [6:0] sm_duan;

reg [3:0]wei_ctrl=4'b1110; 
reg clkdiv;

integer cnt;

always @(posedge clk)
    if(cnt==32'd100_000) 
    begin
    cnt <= 1'b0; 
    clkdiv <= ~clkdiv;
    end 
    else cnt <= cnt + 1'b1;

reg [3:0]duan_ctrl;

always @(posedge clkdiv)
wei_ctrl <= {wei_ctrl[2:0],wei_ctrl[3]};

always @(wei_ctrl) 

    case(hi_lo)
    1'b0:
        case(wei_ctrl)
        4'b1110:duan_ctrl=data[3:0]; 
        4'b1101:duan_ctrl=data[7:4];
        4'b1011:duan_ctrl=data[11:8];
        4'b0111:duan_ctrl=data[15:12]; 
        default:duan_ctrl=4'hf;
        endcase
    1'b1:
        case(wei_ctrl)
        4'b1110:duan_ctrl=data[19:16]; 
        4'b1101:duan_ctrl=data[23:20];
        4'b1011:duan_ctrl=data[27:24];
        4'b0111:duan_ctrl=data[31:28]; 
        default:duan_ctrl=4'hf;
        endcase
    endcase

reg [6:0]duan;

always @(duan_ctrl)
    case(duan_ctrl)
    4'h0:duan=7'b100_0000;//0 
    4'h1:duan=7'b111_1001;//1 
    4'h2:duan=7'b010_0100;//2 
    4'h3:duan=7'b011_0000;//3 
    4'h4:duan=7'b001_1001;//4 
    4'h5:duan=7'b001_0010;//5 
    4'h6:duan=7'b000_0010;//6 
    4'h7:duan=7'b111_1000;//7 
    4'h8:duan=7'b000_0000;//8 
    4'h9:duan=7'b001_0000;//9 
    4'ha:duan=7'b000_1000;//a 
    4'hb:duan=7'b000_0011;//b 
    4'hc:duan=7'b100_0110;//c 
    4'hd:duan=7'b010_0001;//d 
    4'he:duan=7'b000_0111;//e       
    4'hf:duan=7'b000_1110;//f
    // 4'hf:duan=7'b111_1111;//不显示 
    default : duan = 8'b1100_0000;
    endcase

assign sm_wei = wei_ctrl; 
assign sm_duan = duan;

endmodule


// module display(clk,data,which,seg); 
// input clk;
 
// input [15:0] data; 
// output [3:0] which; 
// output [6:0] seg;
 
// reg [3:0]ctrl=4'b1110; 
// always @(posedge clk) 
//     ctrl <= {ctrl[2:0],ctrl[3]}; //段控制

// reg [3:0]duan_ctrl;
 
// always @(ctrl)
//     case(ctrl) 
//     4'b1110:duan_ctrl=data[3:0]; 
//     4'b1101:duan_ctrl=data[7:4]; 
//     4'b1011:duan_ctrl=data[11:8]; 
//     4'b0111:duan_ctrl=data[15:12];
//     default:duan_ctrl=4'hf;
//     endcase
 
 
// //段码译码控制 
// reg [6:0]regseg;
 
// always @(duan_ctrl) 
//     case(duan_ctrl) 
//     4'h0:regseg=7'b100_0000;//0 
//     4'h1:regseg=7'b111_1001;//1 
//     4'h2:regseg=7'b010_0100;//2 
//     4'h3:regseg=7'b011_0000;//3 
//     4'h4:regseg=7'b001_1001;//4 
//     4'h5:regseg=7'b001_0010;//5 
//     4'h6:regseg=7'b000_0010;//6 
//     4'h7:regseg=7'b111_1000;//7 
//     4'h8:regseg=7'b000_0000;//8 
//     4'h9:regseg=7'b001_0000;//9 
//     4'ha:regseg=7'b000_1000;//a 
//     4'hb:regseg=7'b000_0011;//b 
//     4'hc:regseg=7'b100_0110;//c 
//     4'hd:regseg=7'b010_0001;//d 
//     4'he:regseg=7'b000_0111;//e      
//     4'hf:regseg=7'b000_1110;//f
//     default : regseg = 7'b100_0000;//0
//     endcase
 
// assign which = ctrl; 
// assign seg = regseg; 
// endmodule

