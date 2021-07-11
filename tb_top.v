`timescale 1 ns / 100 ps
module tb_top();

reg i_clk, i_start;
wire o_busy_1, o_busy_2, o_busy_3, o_busy_4; 

parameter clk_period=20;

integer DRAM_out;
integer counter = 0;
integer c_start;

 

top DUT (.i_clk(i_clk), .i_start(i_start), .o_busy_1(o_busy_1), .o_busy_2(o_busy_2)
				, .o_busy_3(o_busy_3), .o_busy_4(o_busy_4));
						
always
		#(clk_period/2) i_clk = ~i_clk; 

always @(i_clk) begin
	if (~o_busy_1 & ~o_busy_2 & ~o_busy_3 & ~o_busy_4) begin
	if (counter >= c_start) begin
            $fwrite(DRAM_out, "%h ", DUT.MCU.dram.memory[counter]);
    end
	if (counter == 511) begin
		$fclose(DRAM_out);
        $stop;
	end
	counter = counter + 1;
	end
end
	
initial begin

	i_clk = 1'b0;
	i_start = 1'b0;
	DRAM_out = $fopen("./DRAM_out.mem", "w");
	
	#500;
	c_start = DUT.MCU.dram.memory[12];
	i_start = 1'b1;
	
end
						
endmodule