module top (i_clk, i_start, o_busy);
					
input i_clk, i_start;
output o_busy;

wire [7:0] iram_addr_1, iram_data_in_1, iram_data_out_1, dram_data_in_1, dram_data_out_1;
wire [15:0] dram_addr_1;
wire iram_write_1, iram_read_1, dram_write_1, dram_read_1;

reg clk = 1'b0;
reg [1:0] count=2'd0;

DRAM dram(.address(dram_addr_1), .clock(clk), .data(dram_data_in_1), 
				.rden(dram_read_1), .wren(dram_write_1), .q(dram_data_out_1));
	
IRAM iram(.address(iram_addr_1), .clock(clk), .data(iram_data_in_1), 
				.rden(iram_read_1), .wren(iram_write_1), .q(iram_data_out_1));
	
core #(.core_id(1)) core1 (.i_clk(clk), .i_start(i_start), .i_dram_in(dram_data_out_1), 
				.i_iram_in(iram_data_out_1), .o_dram_addr(dram_addr_1), 
				.o_dram_read(dram_read_1), .o_dram_write(dram_write_1),
				.o_dram_out(dram_data_in_1), .o_iram_addr(iram_addr_1), 
				.o_iram_read(iram_read_1), .o_iram_write(iram_write_1), 
				.o_iram_out(iram_data_in_1), .o_busy(o_busy));  
				
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