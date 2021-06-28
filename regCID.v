module regCID #(parameter [7:0] core_id = 1) (data_out); 

	output reg [7:0] data_out;
	
	always
	begin
	
		data_out <= core_id;
	
	end
	
endmodule