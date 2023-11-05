module Registers
(
    rst_i,
    clk_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i, 
    RDdata_i,
    RegWrite_i, 
    RS1data_o, 
    RS2data_o 
);

// Ports
input               rst_i;
input               clk_i;
input   [4:0]       RS1addr_i;
input   [4:0]       RS2addr_i;
input   [4:0]       RDaddr_i;
input   [31:0]      RDdata_i;
input               RegWrite_i;
output  [31:0]      RS1data_o; 
output  [31:0]      RS2data_o;
integer i;

// Register File
reg signed [31:0]      register        [0:31];

// Read Data      
assign  RS1data_o = register[RS1addr_i];
assign  RS2data_o = register[RS2addr_i];

// Write Data   
always@(posedge clk_i or negedge rst_i) begin
    if (~rst_i) begin
        for (i=0; i<32; i++) begin
            register[i] <= 32'b0;
        end
    end
    else if(RegWrite_i && RDaddr_i != 5'b0) begin
        register[RDaddr_i] <= RDdata_i;
    end
end
   
endmodule 