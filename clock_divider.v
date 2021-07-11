module clock_divider (i_clk, o_clk); 

input i_clk;
output reg o_clk = 1'b0;
integer count=0;

always @(posedge i_clk)
begin
	if (count == 3)
	begin
		count <= 0;
		o_clk <= ~o_clk;
	end
	else
		count <= count + 1;
end
					
endmodule