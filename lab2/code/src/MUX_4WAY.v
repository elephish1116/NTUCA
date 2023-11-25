module MUX_4WAY
(
    data00_i,
    data01_i,
    data10_i,
    forward_i,
    data_o
);

input [31:0] data00_i, data01_i, data10_i;
input [1:0] forward_i;
output [31:0] data_o;

assign data_o = (forward_i == 2'b00) ? data00_i :
                (forward_i == 2'b01) ? data01_i :
                (forward_i == 2'b10) ? data10_i : 32'b0;

endmodule