`timescale 1 ps / 1 ps
module tb_dram();
 
	reg [15:0] addr; 
	reg [15:0] no_1;
	reg wr_en;
	reg no_3;
	reg clk;
	reg [7:0] data_in; 
	reg [7:0] no_2; 
	wire [7:0] no_4;
	wire [7:0] data_out;
 
	
 
	DRAM_test DUT (.address_a(addr),
	.address_b(no_1),
	.clock(clk),
	.data_a(data_in),
	.data_b(no_2),
	.wren_a(wr_en),
	.wren_b(no_3),
	.q_a(data_out),
	.q_b(no_4));
 
	always
		#31.25 clk = ~clk; 
 
	initial begin
		no_1 <= 16'b0000000000000000;
		no_2 <= 8'bxxxxxxxx;
		no_3 <= 1'b0;
		addr <= 16'b0000000000000000;
		data_in <= 8'bxxxxxxxx;
		wr_en <= 1'b0;
		clk <= 1'b0; 
		#62.5	
		
		wr_en <= 1'b1;
		
		addr <= 16'b0000010000011000;
		data_in <= 8'b00110001;
		
		#62.5
		
		if (data_out == 8'b00110001)
			$display("test 1 passed");
		else 
			$display("test 1 failed");
		
		addr <= 16'b0000100001011000;
		data_in <= 8'b00110101;
		
		#62.5
		
		if (data_out == 8'b00110101)
			$display("test 2 passed");
		else 
			$display("test 2 failed");
		
		addr <= 16'b0000110101011000;
		data_in <= 8'b00010101;
		
		#62.5
		
		if (data_out == 8'b00010101)
			$display("test 3 passed");
		else 
			$display("test 3 failed");
			
		addr <= 16'b0000000101011001;
		data_in <= 8'b11010101;
		
		#62.5
		
		if (data_out == 8'b11010101)
			$display("test 4 passed");
		else 
			$display("test 4 failed");
			
		wr_en <= 1'b0;
		
		addr <= 16'b0000010000011000;
		
		#62.5
		
		if (data_out == 8'b00110001)
			$display("test 5 passed");
		else 
			$display("test 5 failed");
			
		addr <= 16'b0000110101011000;
		
		#62.5
		
		if (data_out == 8'b00010101)
			$display("test 6 passed");
		else 
			$display("test 6 failed");
			
		wr_en <= 1'b1;
		
		#62.5
		
		if (data_out == 8'b11010101)
			$display("test 7 passed");
		else 
			$display("test 7 failed");
		
		
		#62.5
		    
		$finish;
	end
 
endmodule