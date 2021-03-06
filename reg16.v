module reg16 (clk ,load ,data_in, data_out);

	input clk,load;
	input [15:0] data_in;
	output reg [15:0] data_out;
	
	always @(posedge clk)
	begin
		if (load) data_out <= data_in;
	end
	
endmodule