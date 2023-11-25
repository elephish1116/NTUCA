module HDU
(
    MemRead_i,
    rd_i,
    rs1_i,
    rs2_i,
    NoOp_o,
    PCWrite_o,
    Stall_o
);

input MemRead_i;
input [4:0] rd_i, rs1_i, rs2_i;
output NoOp_o, PCWrite_o, Stall_o;
assign NoOp_o = (MemRead_i && (rd_i == rs1_i || rd_i == rs2_i));
assign PCWrite_o = ~(MemRead_i && (rd_i == rs1_i || rd_i == rs2_i));
assign Stall_o = (MemRead_i && (rd_i == rs1_i || rd_i == rs2_i));

endmodule