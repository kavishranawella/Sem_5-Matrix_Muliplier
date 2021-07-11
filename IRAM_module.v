// IRAM module

module IRAM_module(address, clock, data, rden, wren , q);

input clock, wren, rden;
input [7:0]address;
input [7:0]data;
output reg [7:0]q;

reg [7:0]memory[0:255];

always@(posedge clock) begin
    if (wren) memory[address] <= data;
    if (rden) q <= memory[address];
    // $display("IRAM Address = %d | Instruction = %h", address, memory[address]);
end

initial begin
        $display("Loading IRAM from file");
        $readmemh("./iram.mem", memory);
end

endmodule