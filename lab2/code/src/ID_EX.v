module ID_EX
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    ImmGen_i,
    instr_i,
    data1_i,
    data2_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    data1_o,
    data2_o,
    ImmGen_o,
    EX_rs1_o,
    EX_rs2_o,
    rd_o,
    func3_o,
    func7_o
);

input clk_i, rst_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
input [1:0] ALUOp_i;
input [31:0] ImmGen_i, instr_i, data1_i, data2_i;
output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;
output reg [1:0] ALUOp_o;
output reg [31:0] data1_o, data2_o, ImmGen_o;
output reg [4:0] EX_rs1_o, EX_rs2_o, rd_o;
output reg [2:0] func3_o;
output reg [6:0] func7_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUSrc_o <= 1'b0;
        ALUOp_o <= 2'b11;
        data1_o <= 32'b0;
        data2_o <= 32'b0;
        ImmGen_o <= 32'b0;
        EX_rs1_o <= 5'b0;
        EX_rs2_o <= 5'b0;
        rd_o <= 5'b0;
        func3_o <= 3'b0;
        func7_o <= 7'b0;
    end
    else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        data1_o <= data1_i;
        data2_o <= data2_i;
        ImmGen_o <= ImmGen_i;
        func3_o <= instr_i[14:12];
        func7_o <= instr_i[31:25];
        EX_rs1_o <= instr_i[19:15];
        EX_rs2_o <= instr_i[24:20];
        rd_o <= instr_i[11:7];
    end
end

endmodule