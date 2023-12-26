module Branch_Predictor
(
    rst_i,
    clk_i,
    branch_i,
    EX_branch_i,
    EX_ALUout_i,
    predict_o,
    flush_o
);

reg [1:0]  state;

input clk_i, rst_i, branch_i, EX_branch_i;
input [31:0] EX_ALUout_i;
output predict_o, flush_o;

assign predict_o = (state > 2'b01) ? 1'b1 : 1'b0;
assign flush_o = predict_o & branch_i;

always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        state <= 2'b11;
    end
    else begin
        if (EX_ALUout_i == 32'b0 & (state == 2'b11 || state == 2'b10) & EX_branch_i)
            state <= 2'b11;
        else if (EX_ALUout_i == 32'b0 & state == 2'b01 & EX_branch_i)
            state <= 2'b10;
        else if (EX_ALUout_i == 32'b0 & state == 2'b00 & EX_branch_i)
            state <= 2'b01;
        else if (EX_ALUout_i != 32'b0 & (state == 2'b00 || state == 2'b01) & EX_branch_i)
            state <= 2'b00;
        else if (EX_ALUout_i != 32'b0 & state == 2'b10 & EX_branch_i)
            state <= 2'b01;
        else if (EX_ALUout_i != 32'b0 & state == 2'b11 & EX_branch_i)
            state <= 2'b10;
    end
end

endmodule
