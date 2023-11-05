module Control
(
		Op_i,
		ALUOp_o,
		ALUSrc_o,
		RegWrite_o
);

input [6:0] Op_i;
output ALUSrc_o, RegWrite_o, ALUOp_o;

assign ALUSrc_o = (Op_i == 7'b0110011) ? 1'b0 : 1'b1;
assign ALUOp_o = (Op_i == 7'b0110011) ? 1'b0 : 1'b1;
assign RegWrite_o = 1'b1;

endmodule
