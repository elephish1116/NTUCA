module ALU_Control
(
		func7_i,
		func3_i,
		ALUOp_i,
		ALUCtrl_o
);

input [6:0] func7_i;
input [2:0] func3_i;
input ALUOp_i;
output [2:0] ALUCtrl_o;

assign ALUCtrl_o = (func3_i == 3'b111) ? 3'b000 :
(func3_i == 3'b100) ? 3'b001 :
(func3_i == 3'b001) ? 3'b010 :
(func3_i == 3'b101) ? 3'b110 :
(ALUOp_i == 1'b1)? 3'b011 :
(func7_i == 7'b0000000) ? 3'b011 :
(func7_i == 7'b0100000) ? 3'b100 : 3'b101;

endmodule
