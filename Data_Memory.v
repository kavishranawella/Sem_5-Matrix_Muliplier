//taken from https://stackoverflow.com/questions/36879351/data-memory-unit
//when loop runs for 65536 times the time taken is considerable. test using something smaller => 256

module Data_Memory (
input wire [15:0] address,          // Memory addressess - 16 bit
input wire [7:0] write_data,    // Memory addressess Contents
input wire memwrite, 
input wire memread,
input wire clk,                  // All synchronous elements, including memories, should have a clock signal
output reg [7:0] read_data      // Output of Memory addressess Contents
);

reg [7:0] MEMORY[0:255];  // 256 words of 8-bit memory - 8 bit word size and 256 array size = 256 bytes of memory //65535 instead of 255

integer i;

initial begin   // initialize all memory cells to 0
  read_data <= 0;
  for (i = 0; i < 256; i = i + 1) begin  //65536 instead of 256
    MEMORY[i] = 0;
  end
end

// Using @(address) will lead to unexpected behavior as memories are synchronous elements like registers
always @(posedge clk) begin
  if (memwrite == 1'b1) begin
    MEMORY[address] <= write_data;
  end
  // Use memread to indicate a valid addressess is on the line and read the memory into a register at that addressess when memread is asserted
  if (memread == 1'b1) begin
    read_data <= MEMORY[address];
  end
end

endmodule
