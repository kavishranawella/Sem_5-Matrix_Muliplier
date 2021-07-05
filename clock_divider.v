module clock_divider (i_clk, o_clk); 

input i_clk;
output reg o_clk = 1'b0;
reg [1:0] count=2'd0;

always @(posedge i_clk)
begin
	if (count == 2'd3)
	begin
		count <= 2'd0;
		o_clk <= ~o_clk;
	end
	else
		count <= count + 2'd1;
end
					
endmodule