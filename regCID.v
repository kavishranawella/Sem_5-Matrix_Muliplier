module regCID (dummy, data_out); //#(parameter [7:0] core_id = 8'd1)

	input dummy;
	output reg [7:0] data_out;
	
	always @(dummy)
	begin
	
		data_out <= 8'd1;
	
	end
	
endmodule