module Instruction_Memory(
 input[7:0] pc, //8-bit program counter contains the instrunction memory address
						//to be executed
 output[7:0] instruction
);


reg [7:0] I_MEMORY[0:255];

integer i;

initial begin
  for (i = 0; i < 256; i = i + 1) begin // initiallize all memory cells to 0.
    I_MEMORY[i] = 0;
  end
end

assign instruction =  I_MEMORY[pc]; 

endmodule
