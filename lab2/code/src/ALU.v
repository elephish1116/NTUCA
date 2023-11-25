module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	ALUout_o,
);

input signed [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output [31:0] ALUout_o;

assign ALUout_o = (ALUCtrl_i == 3'b000) ? data1_i & data2_i :
(ALUCtrl_i == 3'b001) ? data1_i ^ data2_i :
(ALUCtrl_i == 3'b010) ? data1_i << data2_i :
(ALUCtrl_i == 3'b011) ? data1_i + data2_i :
(ALUCtrl_i == 3'b100) ? data1_i - data2_i :
(ALUCtrl_i == 3'b101) ? data1_i * data2_i :
(ALUCtrl_i == 3'b110) ? data1_i >>> (data2_i & 12'b000000011111) : 32'b0;

endmodule
