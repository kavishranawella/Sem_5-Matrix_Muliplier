module core #(parameter core_id = 0) (i_clk, i_start, i_dram_in, i_iram_in, o_dram_addr, o_dram_read,
					o_dram_write, o_dram_out, o_iram_addr, o_iram_read, 
					o_iram_write, o_iram_out, o_busy, o_noc); 

input i_clk;
input i_start;
input [7:0] i_dram_in;
input [7:0] i_iram_in;
output [15:0] o_dram_addr;
output [1:0] o_dram_read;
output [1:0] o_dram_write;
output [7:0] o_dram_out;
output [7:0] o_iram_addr;
output o_iram_read;
output o_iram_write;
output [7:0] o_iram_out;
output o_busy;
output [2:0] o_noc;

wire neg_clk;
wire [15:0] mux_out;

wire [7:0]  mux_in_DR;
wire [15:0] mux_in_PR;
wire [15:0] mux_in_SR;
wire [15:0] mux_in_CDR;
wire [15:0] mux_in_R;
wire [7:0]  mux_in_TR;
wire [15:0] mux_in_A;
wire [15:0] mux_in_B;
wire [15:0] mux_in_C;
wire [15:0] mux_in_AC;
wire [15:0] mux_in_CLA;
wire [7:0]  mux_in_NOC;
wire [7:0]  mux_in_CID;
wire [15:0] dummy_16;
wire [7:0]  dummy_8;

wire inc_PC;
wire inc_R;
wire inc_A;
wire inc_B;
wire inc_C;
wire inc_AC;
wire inc_AR;

wire clear_AC;
wire dec_AC;

wire rst_PC;

wire load_PC;
wire load_IR;
wire load_AR;
wire load_DR;
wire load_PR;
wire load_SR;
wire load_CDR;
wire load_R;
wire load_TR;
wire load_A;
wire load_B;
wire load_C;
wire load_AC;
wire load_CLA;
wire load_NOC;

wire zflag;
wire [15:0] alu_in;
wire [2:0] alu_control;
wire alu_load;

wire [7:0] instruction;
wire [4:0] mux_sig; 
wire [3:0] load_decode_sig;
wire [2:0] inc_decode_sig;


regPC  PC  (.clk(neg_clk), .rst(rst_PC), .load(load_PC), .inc(inc_PC), .data_in(mux_out[7:0]), .data_out(o_iram_addr));
reg8      IR  (.clk(neg_clk), .load(load_IR), .data_in(mux_out[7:0]), .data_out(instruction)); 
reg16_inc AR  (.clk(neg_clk), .load(load_AR), .inc(inc_AR), .data_in(mux_out), .data_out(o_dram_addr));
reg8      DR  (.clk(neg_clk), .load(load_DR), .data_in(mux_out[7:0]), .data_out(mux_in_DR));
reg16     PR  (.clk(neg_clk), .load(load_PR), .data_in(mux_out), .data_out(mux_in_PR));
reg16     SR  (.clk(neg_clk), .load(load_SR), .data_in(mux_out), .data_out(mux_in_SR));
reg16     CDR (.clk(neg_clk), .load(load_CDR), .data_in(mux_out), .data_out(mux_in_CDR));
reg16_inc R   (.clk(neg_clk), .load(load_R), .inc(inc_R), .data_in(mux_out), .data_out(mux_in_R));
reg8 		 TR  (.clk(neg_clk), .load(load_TR), .data_in(mux_out[7:0]), .data_out(mux_in_TR));
reg16_inc A   (.clk(neg_clk), .load(load_A), .inc(inc_A), .data_in(mux_out), .data_out(mux_in_A));
reg16_inc B   (.clk(neg_clk), .load(load_B), .inc(inc_B), .data_in(mux_out), .data_out(mux_in_B));
reg16_inc C   (.clk(neg_clk), .load(load_C), .inc(inc_C), .data_in(mux_out), .data_out(mux_in_C));

reg16     CLA (.clk(neg_clk), .load(load_CLA), .data_in(mux_out), .data_out(mux_in_CLA));
reg8 		 NOC (.clk(neg_clk), .load(load_NOC), .data_in(mux_out[7:0]), .data_out(mux_in_NOC));
regCID 	#(.core_id(core_id)) CID (.clk(neg_clk), .data_out(mux_in_CID)); 

regAC AC (.clk(neg_clk), .alu_load(alu_load), .mux_load(load_AC), .inc(inc_AC), .clear(clear_AC), 
											.dec(dec_AC), .alu_in(alu_in), .mux_in(mux_out), .data_out(mux_in_AC));

mux_32 data_bus (.in0({dummy_8, mux_in_DR}), .in1(mux_in_PR), .in2(mux_in_SR), 
						.in3(mux_in_CDR), .in4(mux_in_R), .in5({dummy_8, mux_in_TR}), 
						.in6(mux_in_A), .in7(mux_in_B), .in8(mux_in_C), 
						.in9(mux_in_AC), .in10({dummy_8,i_dram_in}), .in11({dummy_8, i_iram_in}), 
						.in12({mux_in_DR, mux_in_TR}), .in13({mux_in_AC[7:0], mux_in_AC[15:8]}), 
						.in14(mux_in_CLA), .in15({dummy_8, mux_in_NOC}), .in16({dummy_8, mux_in_CID}), 
						.in17(dummy_16), .in18(dummy_16), .in19(dummy_16), .in20(dummy_16), .in21(dummy_16), 
						.in22(dummy_16), .in23(dummy_16), .in24(dummy_16), .in25(dummy_16), .in26(dummy_16), 
						.in27(dummy_16), .in28(dummy_16), .in29(dummy_16), .in30(dummy_16), .in31(dummy_16), 
						.sel(mux_sig), .out(mux_out));
						
decoder_4to16 load_sig (.in_sig(load_decode_sig), .out_sig({load_NOC, load_CLA, load_AC, load_C, load_B, 
																					load_A, load_TR, load_R, load_CDR, load_SR, 
																					load_PR, load_DR, load_AR, load_IR, load_PC}));

decoder_3to8 increase_sig (.in_sig(inc_decode_sig), .out_sig({inc_AR, inc_AC, inc_C, inc_B, inc_A, inc_R, inc_PC}));						
						
ALU ALU_ins (.clk(neg_clk), .in1(mux_in_AC), .in2(mux_out), .alu_control(alu_control), .out(alu_in), .zflag(zflag), .ac_load(alu_load));

control_unit CU (.clk(i_clk), .instruction(instruction), .zflag(zflag), .start_sig(i_start),
						.busy_sig(o_busy), .mux_sig(mux_sig), .load_decode_sig(load_decode_sig), 
						.alu_sig(alu_control), .rst_PC(rst_PC), .inc_decode_sig(inc_decode_sig), 
						.clear_ac(clear_AC), .dec_ac(dec_AC), .iram_read(o_iram_read), 
						.iram_write(o_iram_write), .dram_read(o_dram_read), .dram_write(o_dram_write), .noc(mux_in_NOC[2:0]));

assign dummy_16 = 16'b0000000000000000; 
assign dummy_8 = 8'b00000000;

assign o_iram_out = mux_in_DR;
assign o_dram_out = mux_in_DR;

assign neg_clk = ~i_clk;

assign o_noc =  mux_in_NOC[2:0];

endmodule
