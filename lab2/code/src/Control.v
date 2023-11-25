module Control
(
	Opcode_i,
	NoOp_i,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	Branch_o,
	MemWrite_o
);

input [6:0] Opcode_i;
input NoOp_i;
output ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, Branch_o, MemWrite_o;
output [1:0] ALUOp_o;

assign ALUSrc_o = ((Opcode_i == 7'b0000011 || Opcode_i == 7'b0100011 || Opcode_i == 7'b0010011) && ~NoOp_i);
assign RegWrite_o = ((Opcode_i == 7'b0110011 || Opcode_i == 7'b0010011 || Opcode_i == 7'b0000011) && ~NoOp_i);
assign MemtoReg_o = (Opcode_i == 7'b0000011 && ~NoOp_i);
assign Branch_o = (Opcode_i == 7'b1100011 && ~NoOp_i);
assign MemRead_o = (Opcode_i == 7'b0000011 && ~NoOp_i);
assign MemWrite_o = (Opcode_i == 7'b0100011 && ~NoOp_i);
assign ALUOp_o = (Opcode_i == 7'b0110011 && ~NoOp_i) ? 2'b10 :
                 (Opcode_i == 7'b1100011 && ~NoOp_i) ? 2'b01 :
				                           (~NoOp_i) ? 2'b00 : 2'b11;
										   
endmodule
