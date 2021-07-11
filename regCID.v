module regCID #(parameter core_id = 0) (clk, data_out); 

	input clk;
	output reg [7:0] data_out;
	
	initial
	begin
	
		data_out <= core_id;
	
	end
	
endmodule