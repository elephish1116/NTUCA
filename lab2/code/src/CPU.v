module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] instruction;
wire [4:0] rs1, rs2;
wire [6:0] opcode;
wire flush;

assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign opcode = instruction[6:0];

MUX_2WAY MUX1(
	.data0_i        (Add1.data_o),
	.data1_i    	(Add2.data_o),
	.select_i   	(Control.Branch_o & (Registers.RS1data_o == Registers.RS2data_o))
);

PC PC(
    .rst_i      	(rst_i),
    .clk_i      	(clk_i),
    .PCWrite_i  	(HDU.PCWrite_o),
    .pc_i       	(MUX1.data_o)
);

Instruction_Memory Instruction_Memory(
	.addr_i     	(PC.pc_o)
);

Adder Add1(
	.data1_i    	(PC.pc_o),
	.data2_i    	(32'd4)
);

IF_ID IF_ID(
	.clk_i       	(clk_i),
	.rst_i       	(rst_i),
	.instr_i     	(Instruction_Memory.instr_o),
	.pc_i        	(PC.pc_o),
	.flush_i     	(Control.Branch_o & (Registers.RS1data_o == Registers.RS2data_o)),
	.stall_i     	(HDU.Stall_o)
);

Adder Add2(
	.data1_i    	(ImmGen.imm_o << 1),
	.data2_i    	(IF_ID.pc_o)
);

HDU HDU(
	.MemRead_i  	(ID_EX.MemRead_o),
	.rd_i       	(ID_EX.rd_o),
	.rs1_i      	(rs1),
	.rs2_i      	(rs2)
);

Registers Registers(
	.rst_i      	(rst_i),
	.clk_i      	(clk_i),
	.RS1addr_i  	(rs1),
	.RS2addr_i  	(rs2),
	.RDaddr_i   	(MEM_WB.rd_o),
	.RDdata_i   	(MUX3.data_o),
	.RegWrite_i 	(MEM_WB.RegWrite_o)
);

Control Control(
	.Opcode_i   	(opcode),
	.NoOp_i     	(HDU.NoOp_o)
);

ImmGen ImmGen(
	.instr_i    	(instruction)
);

ID_EX ID_EX(
	.clk_i      	(clk_i),
	.rst_i      	(rst_i),
	.RegWrite_i 	(Control.RegWrite_o),
	.MemtoReg_i 	(Control.MemtoReg_o),
	.MemRead_i  	(Control.MemRead_o),
	.MemWrite_i 	(Control.MemWrite_o),
	.ALUOp_i    	(Control.ALUOp_o),
	.ALUSrc_i   	(Control.ALUSrc_o),
	.ImmGen_i   	(ImmGen.imm_o),
	.instr_i    	(instruction),
	.data1_i    	(Registers.RS1data_o),
	.data2_i    	(Registers.RS2data_o)
);

MUX_4WAY MUX11(
	.data00_i    	(ID_EX.data1_o),
    .data01_i    	(MUX3.data_o),
    .data10_i    	(EX_MEM.ALUrslt_o),
    .forward_i   	(FU.forwardA_o)
);

MUX_4WAY MUX22(
	.data00_i    	(ID_EX.data2_o),
    .data01_i    	(MUX3.data_o),
    .data10_i    	(EX_MEM.ALUrslt_o),
    .forward_i   	(FU.forwardB_o)
);

MUX_2WAY MUX2(
	.data0_i     	(MUX22.data_o),
	.data1_i     	(ID_EX.ImmGen_o),
	.select_i    	(ID_EX.ALUSrc_o)
);

FU FU(
	.MEM_RegWrite_i (EX_MEM.RegWrite_o),
    .MEM_rd_i       (EX_MEM.rd_o),
    .WB_RegWrite_i  (MEM_WB.RegWrite_o),
    .WB_rd_i        (MEM_WB.rd_o),
    .EX_rs1_i       (ID_EX.EX_rs1_o),
    .EX_rs2_i       (ID_EX.EX_rs2_o)
);
  
ALU ALU(
	.data1_i         (MUX11.data_o),
	.data2_i         (MUX2.data_o),
	.ALUCtrl_i       (ALU_Control.ALUCtrl_o)
);

ALU_Control ALU_Control(
	.func7_i         (ID_EX.func7_o),
	.func3_i         (ID_EX.func3_o),
	.ALUOp_i         (ID_EX.ALUOp_o)
);

EX_MEM EX_MEM(
    .clk_i           (clk_i),
    .rst_i           (rst_i),
    .RegWrite_i      (ID_EX.RegWrite_o),
    .MemtoReg_i      (ID_EX.MemtoReg_o),
    .MemRead_i       (ID_EX.MemRead_o),
    .MemWrite_i      (ID_EX.MemWrite_o),
    .ALUrslt_i       (ALU.ALUout_o),
    .MUXrslt_i       (MUX22.data_o),
    .rd_i            (ID_EX.rd_o)
);

Data_Memory Data_Memory(
    .clk_i           (clk_i),
    .addr_i          (EX_MEM.ALUrslt_o),
    .MemRead_i       (EX_MEM.MemRead_o),
    .MemWrite_i      (EX_MEM.MemWrite_o),
    .data_i          (EX_MEM.MUXrslt_o)
);

MEM_WB MEM_WB(
	.clk_i           (clk_i),
    .rst_i           (rst_i),
    .RegWrite_i      (EX_MEM.RegWrite_o),
    .MemtoReg_i      (EX_MEM.MemtoReg_o),
    .ALUrslt_i       (EX_MEM.ALUrslt_o),
    .ReadData_i      (Data_Memory.data_o),
    .rd_i            (EX_MEM.rd_o)
);

MUX_2WAY MUX3(
	.data0_i         (MEM_WB.ALUrslt_o),
	.data1_i         (MEM_WB.ReadData_o),
	.select_i        (MEM_WB.MemtoReg_o)
);

endmodule

