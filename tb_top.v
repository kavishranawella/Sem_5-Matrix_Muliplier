`timescale 1 ns / 100 ps
module tb_top();

reg i_clk, i_start;
wire o_busy_1, o_busy_2, o_busy_3, o_busy_4; 

parameter clk_period=20;

 

top DUT (.i_clk(i_clk), .i_start(i_start), .o_busy_1(o_busy_1), .o_busy_2(o_busy_2)
				, .o_busy_3(o_busy_3), .o_busy_4(o_busy_4));
						
always
		#(clk_period/2) i_clk = ~i_clk; 
		
initial begin

	i_clk <= 1'b0;
	i_start <= 1'b0;
	
	#500
	
	i_start <= 1'b1;
	

	#1500000
	
	//i_start <= 1'b0;
	
	//#500
	
	//i_start <= 1'b1;
	
	
	#1500000
//	i_dram_read <= 1'b1;
//	i_dram_addr <= 16'b0000000000100100;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01111100)
//		$display("element 1 correct");
//	else 
//		$display("element 1 wrong");
//	
//	i_dram_addr <= 16'b0000000000100101;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b00101101)
//		$display("element 2 correct");
//	else 
//		$display("element 2 wrong");
//	
//	i_dram_addr <= 16'b0000000000100110;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b11000010)
//		$display("element 3 correct");
//	else 
//		$display("element 3 wrong");
//	
//	i_dram_addr <= 16'b0000000000100111;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01001001)
//		$display("element 4 correct");
//	else 
//		$display("element 4 wrong");
//	
//	i_dram_addr <= 16'b0000000000101000;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b11000100)
//		$display("element 5 correct");
//	else 
//		$display("element 5 wrong");
//	
//	i_dram_addr <= 16'b0000000000101001;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b00110001)
//		$display("element 6 correct");
//	else 
//		$display("element 6 wrong");
//	
//	i_dram_addr <= 16'b0000000000101010;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01000100)
//		$display("element 7 correct");
//	else 
//		$display("element 7 wrong");
//	
//	i_dram_addr <= 16'b0000000000101011;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01000011)
//		$display("element 8 correct");
//	else 
//		$display("element 8 wrong");
//	
//	i_dram_addr <= 16'b0000000000101100;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b11001011)
//		$display("element 9 correct");
//	else 
//		$display("element 9 wrong");
//	
//	i_dram_addr <= 16'b0000000000101101;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01011000)
//		$display("element 10 correct");
//	else 
//		$display("element 10 wrong");
//	
//	i_dram_addr <= 16'b0000000000101110;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01101001)
//		$display("element 11 correct");
//	else 
//		$display("element 11 wrong");
//	
//	i_dram_addr <= 16'b0000000000101111;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01011111)
//		$display("element 12 correct");
//	else 
//		$display("element 12 wrong");
//	
//	i_dram_addr <= 16'b0000000000110000;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b11011100)
//		$display("element 13 correct");
//	else 
//		$display("element 13 wrong");
//	
//	i_dram_addr <= 16'b0000000000110001;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b01111101)
//		$display("element 14 correct");
//	else 
//		$display("element 14 wrong");
//	
//	i_dram_addr <= 16'b0000000000110010;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b00011111)
//		$display("element 15 correct");
//	else 
//		$display("element 15 wrong");
//	
//	i_dram_addr <= 16'b0000000000110011;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b10110001)
//		$display("element 16 correct");
//	else 
//		$display("element 16 wrong");
//	
//	i_dram_addr <= 16'b0000000000110100;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b10111111)
//		$display("element 17 correct");
//	else 
//		$display("element 17 wrong");
//	
//	i_dram_addr <= 16'b0000000000110101;
//	
//	#clk_period
//	
//	if (o_dram_data_out == 8'b11000111)
//		$display("element 18 correct");
//	else 
//		$display("element 18 wrong");
		
	#30
 
	$finish;
end
						
endmodule