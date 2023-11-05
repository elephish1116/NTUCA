module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] instruction_addr, instruction, pc;
wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;
wire [11:0] imm;
wire [6:0] func7;
wire [2:0] func3;
assign opcode = instruction[6:0];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd = instruction[11:7];
assign imm = instruction[31:20];
assign func7 = instruction[31:25];
assign func3 = instruction[14:12];
//wire [31:0] RS1data, RS2data;
wire zero;

Control Control(
		.Op_i				(opcode),
		.ALUOp_o		(ALU_Control.ALUOp_i),
		.ALUSrc_o		(MUX_ALUSrc.ALUSrc_i),
		.RegWrite_o	(RegWrite_i)
);

Adder Add_PC(
		.data1_i		(instruction_addr),
		.data2_i		(32'd4),
		.data_o			(pc)
);

PC PC(
		.clk_i			(clk_i),
		.rst_i			(rst_i),
		.pc_i				(pc),
		.pc_o				(instruction_addr)
);

Instruction_Memory Instruction_Memory(
		.addr_i			(instruction_addr),
		.instr_o		(instruction)
);

Registers Registers(
		.rst_i			(rst_i),
		.clk_i			(clk_i),
		.RS1addr_i	(rs1),
		.RS2addr_i	(rs2),
		.RDaddr_i		(rd),
		.RDdata_i		(ALU.ALUout_o),
		.RegWrite_i	(Control.RegWrite_o),
		.RS1data_o	(ALU.data1_i),
		.RS2data_o	(MUX_ALUSrc.data2_i)
);

MUX32 MUX_ALUSrc(
		.data2_i		(Registers.RS2data_o),
		.extend_i		(Sign_Extend.data_o),
		.ALUSrc_i		(Control.ALUSrc_o),
		.data_o			(ALU.data2_i)
);

Sign_Extend Sign_Extend(
		.data_i			(imm),
		.data_o			(MUX_ALUSrc.extend_i)
);
  
ALU ALU(
		.data1_i		(Registers.RS1data_o),
		.data2_i		(MUX_ALUSrc.data_o),
		.ALUCtrl_i	(ALU_Control.ALUCtrl_o),
		.ALUout_o		(Registers.RDdata_i),
		.zero_o			(zero)
);

ALU_Control ALU_Control(
		.func7_i		(func7),
		.func3_i		(func3),
		.ALUOp_i		(Control.ALUOp_o),
		.ALUCtrl_o	(ALU.ALUCtrl_i)
);

endmodule

