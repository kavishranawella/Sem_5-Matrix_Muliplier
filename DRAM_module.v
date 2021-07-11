// DRAM module

module DRAM_module(address, clock, data, rden, wren , q);

input clock, wren, rden;
input [15:0]address;
input [7:0]data;
output reg [7:0]q;

reg [7:0]memory[0:511];

always@(posedge clock) begin
    if (wren) memory[address] <= data;
    if (rden) q <= memory[address];
end

initial begin
        $display("Loading DRAM from file");
        $readmemh("./dram.mem", memory);
end

endmodule