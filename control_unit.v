module control_unit (clk, instruction, zflag, start_sig, busy_sig, mux_sig, 
							load_decode_sig, alu_sig, rst_PC, inc_decode_sig, clear_ac, 
							dec_ac, iram_read, iram_write, dram_read, dram_write, noc);

input clk;
input [7:0] instruction;
input zflag;
input start_sig;
input [2:0] noc;
output reg [4:0] mux_sig;
output reg [3:0] load_decode_sig;
output reg [2:0] alu_sig;
output reg [2:0] inc_decode_sig;
output reg busy_sig;
output reg rst_PC;
output reg clear_ac;
output reg dec_ac;
output reg iram_read;
output reg iram_write;
output reg [1:0] dram_read;
output reg [1:0] dram_write;

reg [6:0] state = 7'd49;

parameter read_off=2'b00, read_same=2'b01, read_different=2'b11;
parameter write_off=2'b00, write_same=2'b01, write_different=2'b11;

parameter load_off=4'b0000, load_PC=4'b0001, load_IR=4'b0010, load_AR=4'b0011,
				load_DR=4'b0100, load_PR=4'b0101, load_SR=4'b0110, load_CDR=4'b0111,
				load_R=4'b1000, load_TR=4'b1001, load_A=4'b1010, load_B=4'b1011,
				load_C=4'b1100, load_AC=4'b1101, load_CLA=4'b1110, load_NOC=4'b1111;

parameter sel_DR=5'b00000, sel_PR=5'b00001, sel_SR=5'b00010, sel_CDR=5'b00011,
				sel_R=5'b00100, sel_TR=5'b00101, sel_A=5'b00110, sel_B=5'b00111,
				sel_C=5'b01000, sel_AC=5'b01001, sel_dram=5'b01010, sel_iram=5'b01011,
				sel_DRTR=5'b01100, sel_ACinv=5'b01101, sel_CLA=5'b01110,
				sel_NOC=5'b01111, sel_CID=5'b10000, sel_none=5'b11111;
				
parameter inc_off=3'b000, inc_PC=3'b001, inc_R=3'b010, inc_A=3'b011, 
				inc_B=3'b100, inc_C=3'b101, inc_AC=3'b110, inc_AR=3'b111;
				
parameter ALU_inactive=3'b000, ALU_add=3'b010, ALU_mul=3'b001, ALU_sub=3'b011, 
				ALU_div=3'b100;
				
parameter NOP=4'b0000,  CLAC=4'b0001,  LDAC=4'b0010,  STAC=4'b0011, MVR=4'b0100,
				 MVAC=4'b0101, MUL=4'b0110, ADD=4'b0111, SUB=4'b1000, DIV=4'b1001,
				 JPNZ=4'b1010, INCAC=4'b1011, DECAC=4'b1100, END=4'b1111;
				 
parameter JUMP=4'b0000, LAST=4'b1111;
					
parameter LOAD=4'b0000, IA=4'b0001, IB=4'b0010;

parameter STORE=4'b0000, IC=4'b0011;

parameter A=4'b0001, B=4'b0010, C=4'b0011, SR=4'b0100, CDR=4'b0101, PR=4'b0110, 
				R=4'b0111, SR_IR=4'b1000, NOC=4'b1001, CID=4'b1010, CLA=4'b1011;
				
parameter FETCH1=7'd0,  FETCH2=7'd1, FETCH3=7'd2, FETCH4=7'd3, NOP1=7'd4, 
			 CLAC1=7'd5, LDAC1=7'd6, LDAC2=7'd7, LDAC3=7'd8, LDAC4=7'd9,
			 LDAC5=7'd10, LDAC6=7'd11, LDAC7=7'd12, LDAC8=7'd13, LDAC9=7'd14,
			 LDAC10=7'd15, LDAC11=7'd16, LDAC_IA1=7'd17, LDAC_IA2=7'd18, LDAC_IA3=7'd19, 
			 LDAC_IA4=7'd20, LDAC_IA5=7'd21, LDAC_IA6=7'd22, LDAC_IA7=7'd23, LDAC_IB1=7'd24, 
			 LDAC_IB2=7'd25, LDAC_IB3=7'd26, LDAC_IB4=7'd27, STAC1=7'd28, STAC2=7'd29, 
			 STAC3=7'd30, STAC4=7'd31, STAC5=7'd32, STAC6=7'd33, STAC7=7'd34,
			 STAC_IC1=7'd35, STAC_IC2=7'd36, STAC_IC3=7'd37, STAC_IC4=7'd38, STAC_IC5=7'd39, 
			 STAC_IC6=7'd40, STAC_IC7=7'd41, STAC_IC8=7'd42, STAC_IC9=7'd43, STAC_IC10=7'd44,
			 MVR_SR1=7'd45, MVR_CDR1=7'd46, MVR_A1=7'd47,  MVR_CID1=7'd48,  MVR_CLA1=7'd49, 
			 MVAC_A1=7'd50, MVAC_B1=7'd51, MVAC_C1=7'd52, MVAC_NOC1=7'd53, MVAC_CLA1=7'd54, 
			 MVAC_CDR1=7'd55, MVAC_SR1=7'd56, MVAC_PR1=7'd57, MVAC_R1=7'd58, MUL_PR1=7'd59, 
			 ADD_SR1=7'd60, ADD_CDR1=7'd61, ADD_SR_IR1=7'd62, SUB_R1=7'd63, SUB_CDR1=7'd64, 
			 DIV_NOC1=7'd65, JPNZY1=7'd66, JPNZY2=7'd67, JPNZY3=7'd68, JPNZN1=7'd69, 
			 JPNZ_LASTY1=7'd70, JPNZ_LASTY2=7'd71, JPNZ_LASTY3=7'd72, JPNZ_LASTN1=7'd73, INCAC1=7'd74, 
			 DECAC1=7'd75,END1=7'd76; 
				
always @(posedge clk)
begin
	case (state)
		
		FETCH1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH2;
		end
		
		FETCH2:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH3;
		end
		
		FETCH3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_IR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH4;
		end
		
		FETCH4:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			
			case (instruction[7:4])
			
				NOP : state <= NOP1;
				
				CLAC : state <= CLAC1;
				
				LDAC : 
				begin	
					
					case (instruction[3:0])
					
						LOAD : state <= LDAC1;
						
						IA : state <= LDAC_IA1;
						
						IB : state <= LDAC_IB1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				STAC : 
				begin	
					
					case (instruction[3:0])
					
						STORE : state <= STAC1;
						
						IC : state <= STAC_IC1;
						
						default : state <= END1;
						
					endcase
				
				end	
				
				MVR : 
				begin	
					
					case (instruction[3:0])
					
						SR : state <= MVR_SR1;
						
						CDR : state <= MVR_CDR1;
						
						A : state <= MVR_A1;
						
						CID : state <= MVR_CID1;
						
						CLA : state <= MVR_CLA1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				MVAC : 
				begin	
					
					case (instruction[3:0])
						
						A : state <= MVAC_A1;
						
						B : state <= MVAC_B1;
						
						C : state <= MVAC_C1;
						
						CDR : state <= MVAC_CDR1;
						
						SR : state <= MVAC_SR1;
						
						PR : state <= MVAC_PR1;
						
						R : state <= MVAC_R1;
						
						NOC : state <= MVAC_NOC1;
						
						CLA : state <= MVAC_CLA1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				MUL : 
				begin	
					
					case (instruction[3:0])
						
						PR : state <= MUL_PR1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				ADD : 
				begin	
					
					case (instruction[3:0])
						
						CDR : state <= ADD_CDR1;
						
						SR : state <= ADD_SR1;
						
						SR_IR : state <= ADD_SR_IR1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				SUB : 
				begin	
					
					case (instruction[3:0])
						
						CDR : state <= SUB_CDR1;
						
						R : state <= SUB_R1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				DIV : 
				begin	
					
					case (instruction[3:0])
						
						NOC : state <= DIV_NOC1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				JPNZ : 
				begin	
				
					case (instruction[3:0])
					
						JUMP :
						begin
					
							case (zflag)
								
								1'b0 : state <= JPNZY1;
								
								1'b1 : state <= JPNZN1;
								
								default : state <= END1;
								
							endcase
						
						end
						
						LAST :
						begin
					
							case (zflag)
								
								1'b0 : state <= JPNZ_LASTY1;
								
								1'b1 : state <= JPNZ_LASTN1;
								
								default : state <= END1;
								
							endcase
						
						end
						
						default : state <= END1;
					
					endcase
				
				end
				
				INCAC : state <= INCAC1;
				
				DECAC : state <= DECAC1;
				
				END : state <= END1;
				
				default : state <= END1;
			
			endcase
			
		end
		
		NOP1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		CLAC1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b1;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		LDAC1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC2;
		end
		
		LDAC2:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC3;
		end
		
		LDAC3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_TR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC4;
		end
		
		LDAC4:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC5;
		end
		
		LDAC5:
		begin
			mux_sig <= sel_DRTR;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC6;
		end
		
		LDAC6:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC7;
		end
		
		LDAC7:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC8;
		end
		
		LDAC8:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_TR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_AR;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC9;
		end
		
		LDAC9:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC10;
		end
		
		LDAC10:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC11;
		end
		
		LDAC11:
		begin
			mux_sig <= sel_DRTR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		LDAC_IA1:
		begin
			mux_sig <= sel_A;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_different;
			dram_write <= write_off;
			if (noc == 3'd1)
				state <= LDAC_IA5;
			else
				state <= LDAC_IA2;
		end
		
		LDAC_IA2:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_different;
			dram_write <= write_off;
			if (noc == 3'd2)
				state <= LDAC_IA5;
			else
				state <= LDAC_IA3;
		end
		
		LDAC_IA3:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_different;
			dram_write <= write_off;
			if (noc == 3'd3)
				state <= LDAC_IA5;
			else
				state <= LDAC_IA4;
		end
		
		LDAC_IA4:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_different;
			dram_write <= write_off;
			state <= LDAC_IA5;
		end
		
		LDAC_IA5:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_different;
			dram_write <= write_off;
			state <= LDAC_IA6;
		end
		
		LDAC_IA6:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_A;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b1;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC_IA7;
		end
		
		LDAC_IA7:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		LDAC_IB1:
		begin
			mux_sig <= sel_B;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC_IB2;
		end
		
		LDAC_IB2:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_same;
			dram_write <= write_off;
			state <= LDAC_IB3;
		end
		
		LDAC_IB3:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_B;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b1;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= LDAC_IB4;
		end
		
		LDAC_IB4:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		STAC1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC2;
		end
		
		STAC2:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC3;
		end
		
		STAC3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_TR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC4;
		end
		
		STAC4:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC5;
		end
		
		STAC5:
		begin
			mux_sig <= sel_DRTR;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC6;
		end
		
		STAC6:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_same;
			state <= STAC7; 
		end
		
		STAC7:
		begin
			mux_sig <= sel_ACinv;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_AR;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_same;
			state <= FETCH1; 
		end
		
		STAC_IC1:
		begin
			mux_sig <= sel_C;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC_IC2;
		end
		
		STAC_IC2:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_C;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd1)
				state <= STAC_IC6;
			else
				state <= STAC_IC3;
		end
		
		STAC_IC3:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd2)
				state <= STAC_IC6;
			else
				state <= STAC_IC4;
		end
		
		STAC_IC4:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd3)
				state <= STAC_IC6;
			else
				state <= STAC_IC5;
		end
		
		STAC_IC5:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			state <= STAC_IC6;
		end
		
		STAC_IC6:
		begin
			mux_sig <= sel_C;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= STAC_IC7;
		end
		
		STAC_IC7:
		begin
			mux_sig <= sel_ACinv;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_C;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd1)
				state <= FETCH1;
			else
				state <= STAC_IC8;  
		end
		
		STAC_IC8:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd2)
				state <= FETCH1;
			else
				state <= STAC_IC9;
		end
		
		STAC_IC9:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			if (noc == 3'd3)
				state <= FETCH1;
			else
				state <= STAC_IC10;
		end
		
		STAC_IC10:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_different;
			state <= FETCH1;
		end
		
		MVR_SR1:
		begin
			mux_sig <= sel_SR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVR_CDR1:
		begin
			mux_sig <= sel_CDR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVR_A1:
		begin
			mux_sig <= sel_A;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVR_CID1:
		begin
			mux_sig <= sel_CID;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVR_CLA1:
		begin
			mux_sig <= sel_CLA;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_A1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_A;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_B1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_B;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_C1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_C;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_CDR1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_CDR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_SR1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_SR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_PR1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_PR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_R1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_R;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_NOC1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_NOC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MVAC_CLA1:
		begin
			mux_sig <= sel_AC;
			load_decode_sig <= load_CLA;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		MUL_PR1:
		begin
			mux_sig <= sel_PR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_mul;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		ADD_CDR1:
		begin
			mux_sig <= sel_CDR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_add;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		ADD_SR1:
		begin
			mux_sig <= sel_SR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_add;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		ADD_SR_IR1:
		begin
			mux_sig <= sel_SR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_add;
			inc_decode_sig <= inc_R;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		SUB_R1:
		begin
			mux_sig <= sel_R;
			load_decode_sig <= load_off;
			alu_sig <= ALU_sub;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		SUB_CDR1:
		begin
			mux_sig <= sel_CDR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_sub;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1; 
		end
		
		DIV_NOC1:
		begin
			mux_sig <= sel_NOC;
			load_decode_sig <= load_off;
			alu_sig <= ALU_div;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		JPNZY1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= JPNZY2;
		end
		
		JPNZY2:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= JPNZY3;
		end
		
		JPNZY3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_PC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		JPNZN1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		JPNZ_LASTY1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= JPNZ_LASTY2;
		end
		
		JPNZ_LASTY2:
		begin
			mux_sig <= sel_iram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= JPNZ_LASTY3;
		end
		
		JPNZ_LASTY3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_PC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= END1;
		end
		
		JPNZ_LASTN1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_PC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		INCAC1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_AC;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		DECAC1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b1;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= FETCH1;
		end
		
		END1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			if (start_sig)	
			begin
				rst_PC <= 1'b0;
				state <= END1;
			end
			else 
			begin
				rst_PC <= 1'b1;
				state <= FETCH1;
			end
		end
		
		default:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b0;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			dec_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= read_off;
			dram_write <= write_off;
			state <= END1;
		end
		
		
		
	endcase
end


endmodule