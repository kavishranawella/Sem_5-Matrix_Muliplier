module memory_control_unit_state(clk, read, write, noc, mux_address_sig, 
                        mux_data_in_sig, mux_data_out_sig);

input clk; 
input [1:0] read, write;
input [3:0] noc;
output reg [1:0] mux_address_sig, mux_data_in_sig;
output reg [3:0] mux_data_out_sig;

reg [3:0] state = 4'd0;

parameter idle=4'd0, read_different1=4'd1, read_different2=4'd2, read_different3=4'd3,
				write_different1=4'd4, write_different2=4'd5, write_different3=4'd6;

always @(posedge clk)
begin

	case (state)
	
		idle:
		begin
		
			if (write[0] == 1'b1)
			begin
				if (write[1] == 1'b1)
				begin
					if (noc == 3'd1)
					begin
						state<=idle;
						mux_address_sig<=2'b00;
						mux_data_in_sig<=2'b00;
						mux_data_out_sig<=4'b0000;
					end
					else
					begin
						state<=write_different1;
						mux_address_sig<=2'b01;
						mux_data_in_sig<=2'b01;
						mux_data_out_sig<=4'b0000;
					end
				end
				else
				begin 
					state<=idle;
					mux_address_sig<=2'b00;
					mux_data_in_sig<=2'b00;
					mux_data_out_sig<=4'b0000;
				end
			end
			
			else if (read[0] == 1'b1)
			begin
				if (read[1] == 1'b1)
				begin
					if (noc == 3'd1)
					begin
						state<=idle;
						mux_address_sig<=2'b00;
						mux_data_in_sig<=2'b00;
						mux_data_out_sig<=4'b0001;
					end
					else
					begin
						state<=read_different1;
						mux_address_sig<=2'b01;
						mux_data_in_sig<=2'b01;
						mux_data_out_sig<=4'b0001;
					end
				end
				else
				begin 
					state<=idle;
					mux_address_sig<=2'b00;
					mux_data_in_sig<=2'b00;
					mux_data_out_sig<=4'b1111;
				end
			end
			
			else
			begin
				state<=idle;
				mux_address_sig<=2'b00;
				mux_data_in_sig<=2'b00;
				mux_data_out_sig<=4'b0000;
			end
			
		end
		
		read_different1:
		begin
			
			if (noc == 3'd2)
			begin
				state<=idle;
				mux_address_sig<=2'b00;
				mux_data_in_sig<=2'b00;
				mux_data_out_sig<=4'b0010;
			end
			else
			begin
				state<=read_different2;
				mux_address_sig<=2'b10;
				mux_data_in_sig<=2'b10;
				mux_data_out_sig<=4'b0010;
			end
			
		end
		
		read_different2:
		begin
		
			if (noc == 3'd3)
			begin
				state<=idle;
				mux_address_sig<=2'b00;			
				mux_data_in_sig<=2'b00;			
				mux_data_out_sig<=4'b0100;
			end
			else
			begin
				state<=read_different3;
				mux_address_sig<=2'b11;			
				mux_data_in_sig<=2'b11;			
				mux_data_out_sig<=4'b0100;
			end
			
		end
		
		read_different3:
		begin
		
			state<=idle;
			mux_address_sig<=2'b00;
			mux_data_in_sig<=2'b00;
			mux_data_out_sig<=4'b1000;
			
		end
		
		write_different1:
		begin
		
			if (noc == 3'd2)
			begin
				state<=idle;
				mux_address_sig<=2'b00;
				mux_data_in_sig<=2'b00;			
				mux_data_out_sig<=4'b0000;
			end
			else
			begin
				state<=write_different2;
				mux_address_sig<=2'b10;
				mux_data_in_sig<=2'b10;			
				mux_data_out_sig<=4'b0000;
			end
			
		end
		
		write_different2:
		begin
			
			if (noc == 3'd3)
			begin
				state<=idle;
				mux_address_sig<=2'b00;
				mux_data_in_sig<=2'b00;			
				mux_data_out_sig<=4'b0000;
			end
			else
			begin
				state<=write_different3;
				mux_address_sig<=2'b11;
				mux_data_in_sig<=2'b11;			
				mux_data_out_sig<=4'b0000;
			end
			
		end
		
		write_different3:
		begin
		
			state<=idle;
			mux_address_sig<=2'b00;
			mux_data_in_sig<=2'b00;			
			mux_data_out_sig<=4'b0000;
			
		end
		
	endcase
	
end

endmodule