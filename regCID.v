module regCID #(parameter [7:0] core_id = 1) (clk, data_out); 

	input clk;
	output reg [7:0] data_out;
	
	always @(posedge clk)
	begin
	
		data_out <= core_id;
	
	end
	
endmodule