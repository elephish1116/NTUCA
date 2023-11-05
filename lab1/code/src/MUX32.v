module MUX32
(
		data2_i,
		extend_i,
		ALUSrc_i,
		data_o
);

input [31:0] data2_i, extend_i;
input ALUSrc_i;
output [31:0] data_o;

assign data_o = ALUSrc_i ? extend_i : data2_i;

endmodule
