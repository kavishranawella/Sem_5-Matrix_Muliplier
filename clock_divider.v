// Clock divider module
module clock_divider(i_clk, clk);
input i_clk;
output reg clk = 1'b0;

reg [1:0] count = 2'd0;

always @(posedge i_clk)
begin
	if (count == 2'd3)
	begin
		count <= 2'd0;
		clk <= ~clk;
	end
	else
		count <= count + 2'd1;
end	
endmodule