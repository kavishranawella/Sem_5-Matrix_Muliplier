module top_dummy(i_clk, i_start, o_busy_1, o_busy_2, o_busy_3, o_busy_4);

input i_clk, i_start;
output o_busy_1, o_busy_2, o_busy_3, o_busy_4; 

top top_module (.i_clk(i_clk), .i_start(i_start), .o_busy_1(o_busy_1), .o_busy_2(o_busy_2)
				, .o_busy_3(o_busy_3), .o_busy_4(o_busy_4));
						
						
endmodule