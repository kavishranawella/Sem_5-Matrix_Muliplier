module regAC (clk, alu_load, mux_load, inc, clear, alu_in, mux_in, data_out);

	input clk, alu_load, mux_load, inc, clear;
	input [15:0] alu_in, mux_in;
	output reg [15:0] data_out;
	
	always @(posedge clk)
	begin
		if (mux_load) data_out <= mux_in;
		else if (alu_load) data_out <= alu_in;
		else if (inc) data_out <= data_out + 16'b0000000000000001;
		else if (clear) data_out <= 16'b0000000000000000;
		else data_out <= data_out;
	end
	
endmodule