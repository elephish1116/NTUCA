module FU
(
    MEM_RegWrite_i,
    MEM_rd_i,
    WB_RegWrite_i,
    WB_rd_i,
    EX_rs1_i,
    EX_rs2_i,
    forwardA_o,
    forwardB_o
);

input MEM_RegWrite_i, WB_RegWrite_i;
input [4:0] MEM_rd_i, WB_rd_i, EX_rs1_i, EX_rs2_i;
output [1:0] forwardA_o, forwardB_o;

assign forwardA_o = (MEM_RegWrite_i && MEM_rd_i != 0 && MEM_rd_i == EX_rs1_i) ? 2'b10 :
                   (WB_RegWrite_i && WB_rd_i != 0 && WB_rd_i == EX_rs1_i) ? 2'b01 : 2'b00;
assign forwardB_o = (MEM_RegWrite_i && MEM_rd_i != 0 && MEM_rd_i == EX_rs2_i) ? 2'b10 :
                   (WB_RegWrite_i && WB_rd_i != 0 && WB_rd_i == EX_rs2_i) ? 2'b01 : 2'b00;

endmodule