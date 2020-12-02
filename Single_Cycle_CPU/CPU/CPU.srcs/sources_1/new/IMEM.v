`timescale 1ns / 1ps

module IMEM(
    input clkin,            //时钟信号
    input [31:0] pc,        //pc信号
    output [31:0] inst      //输出指令
);

wire[7:0] inst0, inst1, inst2, inst3;
wire[7:0] addr0, addr1, addr2, addr3;

assign addr0 = pc[7:0];
assign addr1 = addr0 + 1'b1;
assign addr2 = addr1 + 1'b1;
assign addr3 = addr2 + 1'b1;


reg[7:0] imem[0:255];

initial 
begin
    imem[0] = 'h24; imem[1] = 'h01; imem[2] = 'h00; imem[3] = 'h08; 
    imem[4] = 'h34; imem[5] = 'h02; imem[6] = 'h00; imem[7] = 'h02; 
    imem[8] = 'h00; imem[9] = 'h41; imem[10] = 'h18; imem[11] = 'h20; 
    imem[12] = 'h00; imem[13] = 'h62; imem[14] = 'h28; imem[15] = 'h22; 
    imem[16] = 'h00; imem[17] = 'ha2; imem[18] = 'h20; imem[19] = 'h24; 
    imem[20] = 'h00; imem[21] = 'h82; imem[22] = 'h40; imem[23] = 'h25; 
    imem[24] = 'h00; imem[25] = 'h08; imem[26] = 'h40; imem[27] = 'h40; 
    imem[28] = 'h15; imem[29] = 'h01; imem[30] = 'hff; imem[31] = 'hfe; 
    imem[32] = 'h28; imem[33] = 'h46; imem[34] = 'h00; imem[35] = 'h04; 
    imem[36] = 'h2c; imem[37] = 'hc7; imem[38] = 'h00; imem[39] = 'h00; 
    imem[40] = 'h24; imem[41] = 'he7; imem[42] = 'h00; imem[43] = 'h08; 
    imem[44] = 'h10; imem[45] = 'he1; imem[46] = 'hff; imem[47] = 'hfe; 
    imem[48] = 'hac; imem[49] = 'h22; imem[50] = 'h00; imem[51] = 'h04; 
    imem[52] = 'h8c; imem[53] = 'h29; imem[54] = 'h00; imem[55] = 'h04; 
    imem[56] = 'h24; imem[57] = 'h0a; imem[58] = 'hff; imem[59] = 'hfe; 
    imem[60] = 'h25; imem[61] = 'h4a; imem[62] = 'h00; imem[63] = 'h01; 
    imem[64] = 'h30; imem[65] = 'h4b; imem[66] = 'h00; imem[67] = 'h02; 
    imem[68] = 'h00; imem[69] = 'h02; imem[70] = 'h50; imem[71] = 'h21; 
    imem[72] = 'h01; imem[73] = 'h42; imem[74] = 'h50; imem[75] = 'h23; 
    imem[76] = 'h01; imem[77] = 'h02; imem[78] = 'h50; imem[79] = 'h26; 
    imem[80] = 'h01; imem[81] = 'h02; imem[82] = 'h50; imem[83] = 'h27; 
    imem[84] = 'h01; imem[85] = 'h02; imem[86] = 'h50; imem[87] = 'h2b; 
    imem[88] = 'h00; imem[89] = 'h08; imem[90] = 'h50; imem[91] = 'h42; 
    imem[92] = 'h00; imem[93] = 'hc8; imem[94] = 'h50; imem[95] = 'h04; 
    imem[96] = 'h00; imem[97] = 'hc8; imem[98] = 'h50; imem[99] = 'h06; 
    imem[100] = 'h20; imem[101] = 'h0a; imem[102] = 'hff; imem[103] = 'hff; 
    imem[104] = 'h00; imem[105] = 'h0a; imem[106] = 'h58; imem[107] = 'h43; 
    imem[108] = 'h00; imem[109] = 'hca; imem[110] = 'h58; imem[111] = 'h07; 
    imem[112] = 'h38; imem[113] = 'h6a; imem[114] = 'h00; imem[115] = 'h07; 
    imem[116] = 'h3c; imem[117] = 'h05; imem[118] = 'h00; imem[119] = 'h0a; 
    imem[120] = 'ha4; imem[121] = 'h23; imem[122] = 'h00; imem[123] = 'h08; 
    imem[124] = 'ha0; imem[125] = 'h23; imem[126] = 'h00; imem[127] = 'h0a; 
    imem[128] = 'h84; imem[129] = 'h2a; imem[130] = 'h00; imem[131] = 'h09; 
    imem[132] = 'h80; imem[133] = 'h2a; imem[134] = 'h00; imem[135] = 'h04; 
    imem[136] = 'h0c; imem[137] = 'h00; imem[138] = 'h00; imem[139] = 'h23; 
    imem[140] = 'h34; imem[141] = 'h01; imem[142] = 'h00; imem[143] = 'h98; 
    imem[144] = 'h00; imem[145] = 'h20; imem[146] = 'h00; imem[147] = 'h08; 
    imem[148] = 'h00; imem[149] = 'h22; imem[150] = 'h50; imem[151] = 'h20; 
    imem[152] = 'h00; imem[153] = 'ha6; imem[154] = 'h50; imem[155] = 'h2a; 
    imem[156] = 'h01; imem[157] = 'h22; imem[158] = 'h00; imem[159] = 'h18; 
    imem[160] = 'h00; imem[161] = 'h00; imem[162] = 'h50; imem[163] = 'h10; 
    imem[164] = 'h00; imem[165] = 'h00; imem[166] = 'h50; imem[167] = 'h12; 
    imem[168] = 'h01; imem[169] = 'h22; imem[170] = 'h00; imem[171] = 'h1a; 
    imem[172] = 'h00; imem[173] = 'h00; imem[174] = 'h50; imem[175] = 'h10; 
    imem[176] = 'h00; imem[177] = 'h00; imem[178] = 'h50; imem[179] = 'h12; 
    imem[180] = 'h08; imem[181] = 'h00; imem[182] = 'h00; imem[183] = 'h2e; 
    imem[184] = 'hfc; imem[185] = 'h00; imem[186] = 'h00; imem[187] = 'h00; 
end




assign inst = {imem[addr0], imem[addr1], imem[addr2], imem[addr3]};

endmodule
