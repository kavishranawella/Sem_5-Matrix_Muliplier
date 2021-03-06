module reg16_inc (clk, load, inc, data_in, data_out);

	input clk, load, inc;
	input [15:0] data_in;
	output reg [15:0] data_out;
	
	always @(posedge clk)
	begin
		if (load) data_out <= data_in;
		else if (inc) data_out <= data_out + 16'b0000000000000001;
	end
	
endmodule