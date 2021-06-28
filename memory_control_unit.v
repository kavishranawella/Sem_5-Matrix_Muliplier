module memory_control_unit(i_clk, i_read, i_write, i_ar1, i_ar2, i_ar3, i_ar4 , 
										i_dr1, i_dr2, i_dr3, i_dr4, 
										o_dr1, o_dr2, o_dr3, o_dr4);
input i_clk;
input i_read;
input i_write;
input [15:0] i_ar1;
input [15:0] i_ar2;
input [15:0] i_ar3;
input [15:0] i_ar4;
input [7:0] i_dr1;
input [7:0] i_dr2;
input [7:0] i_dr3;
input [7:0] i_dr4;
output [7:0] o_dr1;
output [7:0] o_dr2;
output [7:0] o_dr3;
output [7:0] o_dr4;

wire [7:0] dram_data_in;
wire [7:0] dram_data_out;
wire [15:0] dram_address;

reg [1:0] mux_address_sig, mux_data_out_sig, mux_data_in_sig;

reg [3:0] state = 4'd0;

wire neg_clk;

//reg8 DR1 (.clk(neg_clk), .load(load_DR1), .data_in(demux_out1), .data_out(o_dr1));
//reg8 DR2 (.clk(neg_clk), .load(load_DR2), .data_in(demux_out2), .data_out(o_dr2));
//reg8 DR3 (.clk(neg_clk), .load(load_DR3), .data_in(demux_out3), .data_out(o_dr3));
//reg8 DR4 (.clk(neg_clk), .load(load_DR4), .data_in(demux_out4), .data_out(o_dr4));

parameter idle=4'd0, read_core1=4'd1, read_core2=4'd2, read_core3=4'd3, read_core4=4'd4,
				write_core1=4'd5, write_core2=4'd6, write_core3=4'd7, write_core4=4'd8;

//mux_signal?
mux_8 data_in (.in0(i_dr1), .in1(i_dr2), .in2(i_dr3), 
						.in3(i_dr4), .sel(mux_data_in_sig), .out(dram_data_in));

					
mux_16_4inputs data_address (.in0(i_ar1), .in1(i_ar2), .in2(i_ar3), 
						.in3(i_ar4), .sel(mux_address_sig), .out(dram_address));
						
//sel						
demux_8 data_out(.clk(neg_clk), .in(dram_data_out), .out0(o_dr1), .out1(o_dr2), .out2(o_dr3),
						.out3(o_dr4), .sel(mux_data_out_sig)) ;						
						
DRAM dram(.address(dram_address), .clock(i_clk), .data(dram_data_in), 
				.rden(i_read), .wren(i_write), .q(dram_data_out));	
				
assign neg_clk = ~i_clk;

always @(posedge i_clk)
begin

	case (state)
	
		idle:
		begin
		
			if (i_write == 1'b1)
			begin
				state<=write_core2;
				mux_address_sig<=2'b01;
				mux_data_out_sig<=2'b00;
				mux_data_in_sig<=2'b01;
			end
			
			else if (i_read == 1'b1)
			begin
				state<=read_core2;
				mux_address_sig<=2'b01;
				mux_data_out_sig<=2'b00;
				mux_data_in_sig<=2'b01;
			end
			
			else
			begin
				state<=idle;
				mux_address_sig<=2'b00;
				mux_data_out_sig<=2'b00;
				mux_data_in_sig<=2'b00;
			end
			
		end
		
		read_core1:
		begin
		
			mux_data_out_sig<=2'b00;
			mux_address_sig<=2'b01;
			state<=read_core2;
			
			mux_data_in_sig<=2'b01;
			
		end
		
		read_core2:
		begin
		
			mux_data_out_sig<=2'b01;
			mux_address_sig<=2'b10;
			state<=read_core3;
			
			mux_data_in_sig<=2'b10;
			
		end
		
		read_core3:
		begin
		
			mux_data_out_sig<=2'b10;
			mux_address_sig<=2'b11;
			state<=read_core4;
			
			mux_data_in_sig<=2'b11;
			
		end
		
		read_core4:
		begin
		
			mux_data_out_sig<=2'b11;
			mux_address_sig<=2'b00;
			state<=idle;
			
			mux_data_in_sig<=2'b00;
			
		end
		
		write_core1:
		begin
		
			mux_data_in_sig<=2'b01;
			mux_address_sig<=2'b01;
			state<=write_core2;
			
			mux_data_out_sig<=2'b00;
			
		end
		
		write_core2:
		begin
		
			mux_data_in_sig<=2'b10;
			mux_address_sig<=2'b10;
			state<=write_core3;
			
			mux_data_out_sig<=2'b01;
			
		end
		
		write_core3:
		begin
		
			mux_data_in_sig<=2'b11;
			mux_address_sig<=2'b11;
			state<=write_core4;
			
			mux_data_out_sig<=2'b10;
			
		end
		
		write_core4:
		begin
		
			mux_data_in_sig<=2'b00;
			mux_address_sig<=2'b00;
			state<=idle;
			
			mux_data_out_sig<=2'b11;
			
		end
		
	endcase
	
end
				
endmodule