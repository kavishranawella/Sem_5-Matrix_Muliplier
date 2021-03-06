module regPC (clk, rst, load, inc, data_in, data_out);

	input clk, rst, load, inc;
	input [7:0] data_in;
	output reg [7:0] data_out = 8'b00000000;
	
	always @(posedge clk)
	begin
		if (rst) data_out <= 8'b00000000;
		else if (load) data_out <= data_in;
		else if (inc) data_out <= data_out + 8'b00000001;
	end
	
endmodule