module IF_ID
(
    clk_i,
    rst_i,
    instr_i,
    pc_i,
    flush_i,
    stall_i,
    pc_o,
    instr_o
);
input clk_i, rst_i, flush_i, stall_i;
input [31:0] instr_i, pc_i;
output reg [31:0] instr_o, pc_o;

always @(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        instr_o <= 32'b0;
        pc_o <= 32'b0;
    end
    else if (~stall_i) begin
        pc_o <= pc_i;
        instr_o <= (flush_i) ? 32'b0 : instr_i;
    end
end
endmodule