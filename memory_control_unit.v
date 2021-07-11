module memory_control_unit(i_clk, i_read, i_write, i_ar1, i_ar2, i_ar3, i_ar4 , 
										i_dr1, i_dr2, i_dr3, i_dr4, o_dr1, o_dr2, o_dr3, o_dr4, i_noc);

input i_clk;
input [1:0] i_read;
input [1:0] i_write;
input [15:0] i_ar1;
input [15:0] i_ar2;
input [15:0] i_ar3;
input [15:0] i_ar4;
input [7:0] i_dr1;
input [7:0] i_dr2;
input [7:0] i_dr3;
input [7:0] i_dr4;
input [2:0] i_noc;
output [7:0] o_dr1;
output [7:0] o_dr2;
output [7:0] o_dr3;
output [7:0] o_dr4;

wire [7:0] dram_data_in;
wire [7:0] dram_data_out;
wire [15:0] dram_address;

wire [1:0] mux_address_sig, mux_data_in_sig;
wire [3:0] mux_data_out_sig;

wire neg_clk;

reg8 DR1 (.clk(neg_clk), .load(mux_data_out_sig[0]), .data_in(dram_data_out), .data_out(o_dr1));
reg8 DR2 (.clk(neg_clk), .load(mux_data_out_sig[1]), .data_in(dram_data_out), .data_out(o_dr2));
reg8 DR3 (.clk(neg_clk), .load(mux_data_out_sig[2]), .data_in(dram_data_out), .data_out(o_dr3));
reg8 DR4 (.clk(neg_clk), .load(mux_data_out_sig[3]), .data_in(dram_data_out), .data_out(o_dr4));

mux_8 data_in (.in0(i_dr1), .in1(i_dr2), .in2(i_dr3), 
						.in3(i_dr4), .sel(mux_data_in_sig), .out(dram_data_in));

					
mux_16_4inputs data_address (.in0(i_ar1), .in1(i_ar2), .in2(i_ar3), 
						.in3(i_ar4), .sel(mux_address_sig), .out(dram_address));					
						
// DRAM dram(.address(dram_address), .clock(i_clk), .data(dram_data_in), 
// 				.rden(i_read[0]), .wren(i_write[0]), .q(dram_data_out));	

DRAM_module dram(.address(dram_address), .clock(i_clk), .data(dram_data_in), 
				.rden(i_read[0]), .wren(i_write[0]), .q(dram_data_out));	
				
assign neg_clk = ~i_clk;

memory_control_unit_state state(.clk(i_clk), .read(i_read), .write(i_write), 
						.noc(i_noc), .mux_address_sig(mux_address_sig), 
                        .mux_data_in_sig(mux_data_in_sig), 
						.mux_data_out_sig(mux_data_out_sig));
				
endmodule