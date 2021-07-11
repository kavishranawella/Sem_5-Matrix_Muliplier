module top (i_clk, i_start, o_busy_1, o_busy_2, o_busy_3, o_busy_4);
					
input i_clk, i_start;
output o_busy_1, o_busy_2, o_busy_3, o_busy_4;

wire [7:0] iram_data_out;

wire [7:0] iram_addr_1, iram_data_in_1, dram_data_in_1, dram_data_out_1;
wire [15:0] dram_addr_1;
wire iram_write_1, iram_read_1; 
wire [1:0] dram_write_1, dram_read_1;
wire [2:0] noc_1;

wire [7:0] iram_addr_2, iram_data_in_2, dram_data_in_2, dram_data_out_2;
wire [15:0] dram_addr_2;
wire iram_write_2, iram_read_2; 
wire [1:0] dram_write_2, dram_read_2;
wire [2:0] noc_2;

wire [7:0] iram_addr_3, iram_data_in_3, dram_data_in_3, dram_data_out_3;
wire [15:0] dram_addr_3;
wire iram_write_3, iram_read_3; 
wire [1:0] dram_write_3, dram_read_3;
wire [2:0] noc_3;

wire [7:0] iram_addr_4, iram_data_in_4, dram_data_in_4, dram_data_out_4;
wire [15:0] dram_addr_4;
wire iram_write_4, iram_read_4; 
wire [1:0] dram_write_4, dram_read_4;
wire [2:0] noc_4;

wire clk;

memory_control_unit MCU (.i_clk(clk), .i_read(dram_read_1), .i_write(dram_write_1), 
									.i_ar1(dram_addr_1), .i_ar2(dram_addr_2), .i_ar3(dram_addr_3), 
									.i_ar4(dram_addr_4), .i_dr1(dram_data_in_1), .i_dr2(dram_data_in_2), 
									.i_dr3(dram_data_in_3), .i_dr4(dram_data_in_4), .o_dr1(dram_data_out_1), 
									.o_dr2(dram_data_out_2), .o_dr3(dram_data_out_3), .o_dr4(dram_data_out_4), 
									.i_noc(noc_1));

//DRAM dram(.address(dram_addr_1), .clock(clk), .data(dram_data_in_1), 
//				.rden(dram_read_1), .wren(dram_write_1), .q(dram_data_out_1));
	
IRAM iram(.address(iram_addr_1), .clock(clk), .data(iram_data_in_1), 
				.rden(iram_read_1), .wren(iram_write_1), .q(iram_data_out));
	
core #(.core_id(0)) core1 (.i_clk(clk), .i_start(i_start), .i_dram_in(dram_data_out_1), 
				.i_iram_in(iram_data_out), .o_dram_addr(dram_addr_1), 
				.o_dram_read(dram_read_1), .o_dram_write(dram_write_1),
				.o_dram_out(dram_data_in_1), .o_iram_addr(iram_addr_1), 
				.o_iram_read(iram_read_1), .o_iram_write(iram_write_1), 
				.o_iram_out(iram_data_in_1), .o_busy(o_busy_1), .o_noc(noc_1));  
				
core #(.core_id(1)) core2 (.i_clk(clk), .i_start(i_start), .i_dram_in(dram_data_out_2), 
				.i_iram_in(iram_data_out), .o_dram_addr(dram_addr_2), 
				.o_dram_read(dram_read_2), .o_dram_write(dram_write_2),
				.o_dram_out(dram_data_in_2), .o_iram_addr(iram_addr_2), 
				.o_iram_read(iram_read_2), .o_iram_write(iram_write_2), 
				.o_iram_out(iram_data_in_2), .o_busy(o_busy_2), .o_noc(noc_2));  
				
core #(.core_id(2)) core3 (.i_clk(clk), .i_start(i_start), .i_dram_in(dram_data_out_3), 
				.i_iram_in(iram_data_out), .o_dram_addr(dram_addr_3), 
				.o_dram_read(dram_read_3), .o_dram_write(dram_write_3),
				.o_dram_out(dram_data_in_3), .o_iram_addr(iram_addr_3), 
				.o_iram_read(iram_read_3), .o_iram_write(iram_write_3), 
				.o_iram_out(iram_data_in_3), .o_busy(o_busy_3), .o_noc(noc_3));  
				
core #(.core_id(3)) core4 (.i_clk(clk), .i_start(i_start), .i_dram_in(dram_data_out_4), 
				.i_iram_in(iram_data_out), .o_dram_addr(dram_addr_4), 
				.o_dram_read(dram_read_4), .o_dram_write(dram_write_4),
				.o_dram_out(dram_data_in_4), .o_iram_addr(iram_addr_4), 
				.o_iram_read(iram_read_4), .o_iram_write(iram_write_4), 
				.o_iram_out(iram_data_in_4), .o_busy(o_busy_4), .o_noc(noc_4));  
				
clock_divider clk_div (.i_clk(i_clk), .o_clk(clk)); 
					
endmodule