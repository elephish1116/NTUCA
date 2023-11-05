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
wire zero;
wire ALUOp, ALUSrc, RegWrite;
wire [31:0] data1, data2, WriteData, Sign_Extended, MUX_data2;
wire [2:0] ALUCtrl;

Control Control(
		.Op_i       (opcode),
		.ALUOp_o    (ALUOp),
		.ALUSrc_o   (ALUSrc),
		.RegWrite_o (RegWrite)
);

Adder Add_PC(
		.data1_i    (instruction_addr),
		.data2_i    (32'd4),
		.data_o     (pc)
);

PC PC(
		.clk_i      (clk_i),
		.rst_i      (rst_i),
		.pc_i       (pc),
		.pc_o       (instruction_addr)
);

Instruction_Memory Instruction_Memory(
		.addr_i     (instruction_addr),
		.instr_o    (instruction)
);

Registers Registers(
		.rst_i      (rst_i),
		.clk_i      (clk_i),
		.RS1addr_i  (rs1),
		.RS2addr_i  (rs2),
		.RDaddr_i   (rd),
		.RDdata_i   (WriteData),
		.RegWrite_i (RegWrite),
		.RS1data_o  (data1),
		.RS2data_o  (data2)
);

MUX32 MUX_ALUSrc(
		.data2_i    (data2),
		.extend_i   (Sign_Extended),
		.ALUSrc_i   (ALUSrc),
		.data_o     (MUX_data2)
);

Sign_Extend Sign_Extend(
		.data_i     (imm),
		.data_o     (Sign_Extended)
);
  
ALU ALU(
		.data1_i    (data1),
		.data2_i    (MUX_data2),
		.ALUCtrl_i  (ALUCtrl),
		.ALUout_o   (WriteData),
		.zero_o     (zero)
);

ALU_Control ALU_Control(
		.func7_i    (func7),
		.func3_i    (func3),
		.ALUOp_i    (ALUOp),
		.ALUCtrl_o  (ALUCtrl)
);

endmodule

