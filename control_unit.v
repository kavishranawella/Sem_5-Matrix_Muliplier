module control_unit (clk, instruction, zflag, start_sig, busy_sig, mux_sig, 
							load_decode_sig, alu_sig, rst_PC, inc_decode_sig, clear_ac, 
							iram_read, iram_write, dram_read, dram_write);

input clk;
input [7:0] instruction;
input zflag;
input start_sig;
output reg [3:0] mux_sig;
output reg [3:0] load_decode_sig;
output reg [1:0] alu_sig;
output reg [2:0] inc_decode_sig;
output reg busy_sig;
output reg rst_PC;
output reg clear_ac;
output reg iram_read;
output reg iram_write;
output reg dram_read;
output reg dram_write;

reg [5:0] state = 6'd49;

parameter load_off=4'b0000, load_PC=4'b0001, load_IR=4'b0010, load_AR=4'b0011,
				load_DR=4'b0100, load_PR=4'b0101, load_SR=4'b0110, load_CDR=4'b0111,
				load_R=4'b1000, load_TR=4'b1001, load_A=4'b1010, load_B=4'b1011,
				load_C=4'b1100, load_AC=4'b1101;

parameter sel_DR=4'b0000, sel_PR=4'b0001, sel_SR=4'b0010, sel_CDR=4'b0011,
				sel_R=4'b0100, sel_TR=4'b0101, sel_A=4'b0110, sel_B=4'b0111,
				sel_C=4'b1000, sel_AC=4'b1001, sel_dram=4'b1010, sel_iram=4'b1011,
				sel_DRTR=4'b1100, sel_ACinv=4'b1101, sel_none=4'b1111;
				
parameter inc_off=3'b000, inc_PC=3'b001, inc_R=3'b010, inc_A=3'b011, 
				inc_B=3'b100, inc_C=3'b101, inc_AC=3'b110, inc_AR=3'b111;
				
parameter ALU_inactive=2'b00, ALU_add=2'b10, ALU_mul=2'b01, ALU_sub=2'b11;
				
parameter NOP=4'b0000,  CLAC=4'b0001,  LDAC=4'b0010,  STAC=4'b0011, MVR=4'b0100,
				 MVAC=4'b0101, MUL=4'b0110, ADD=4'b0111, SUB=4'b1000, JPNZ=4'b1001,
				   INCAC=4'b1010, END=4'b1111;
					
parameter LOAD=4'b0000, IA=4'b0001, IB=4'b0010;

parameter STORE=4'b0000, IC=4'b0011;

parameter A=4'b0001, B=4'b0010, C=4'b0011, SR=4'b0100, 
				CDR=4'b0101, PR=4'b0110, R=4'b0111, SR_IR=4'b1000;
				
parameter FETCH1=6'd0,  FETCH2=6'd1, FETCH3=6'd2, FETCH4=6'd3, NOP1=6'd4, 
			 CLAC1=6'd5, LDAC1=6'd6, LDAC2=6'd7, LDAC3=6'd8, LDAC4=6'd9,
			 LDAC5=6'd10, LDAC6=6'd11, LDAC7=6'd12, LDAC_IA1=6'd13, LDAC_IA2=6'd14,
			 LDAC_IA3=6'd15, LDAC_IB1=6'd16, LDAC_IB2=6'd17, LDAC_IB3=6'd18, STAC1=6'd19,
			 STAC2=6'd20, STAC3=6'd21, STAC4=6'd22, STAC5=6'd23, STAC6=6'd24,
			 STAC_IC1=6'd25, STAC_IC2=6'd26, STAC_IC3=6'd27, STAC_IC4=6'd28, MVR_SR1=6'd29,
			 MVR_CDR1=6'd30, MVR_A1=6'd31, MVAC_A1=6'd32, MVAC_B1=6'd33, MVAC_C1=6'd34,
			 MVAC_CDR1=6'd35, MVAC_SR1=6'd36, MVAC_PR1=6'd37, MVAC_R1=6'd38, MUL1=6'd39,
			 ADD_SR1=6'd40, ADD_SR_IR1=6'd41, SUB_R1=6'd42, SUB_CDR1=6'd43, JPNZY1=6'd44,
			 JPNZY2=6'd45, JPNZY3=6'd46, JPNZN1=6'd47, INCAC1=6'd48, END1=6'd49,
			 LDAC8=6'd50, LDAC9=6'd51, STAC7=6'd52, ADD_CDR1=6'd53;
				
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			
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
						
						default : state <= END1;
						
					endcase
				
				end
				
				MUL : state <= MUL1;
				
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
				
				JPNZ : 
				begin	
					
					case (zflag)
						
						1'b0 : state <= JPNZY1;
						
						1'b1 : state <= JPNZN1;
						
						default : state <= END1;
						
					endcase
				
				end
				
				INCAC : state <= INCAC1;
				
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b1;
			dram_write <= 1'b0;
			state <= LDAC6;
		end
		
		LDAC6:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= LDAC7;
		end
		
		LDAC7:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_TR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_AR;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b1;
			dram_write <= 1'b0;
			state <= LDAC8;
		end
		
		LDAC8:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= LDAC9;
		end
		
		LDAC9:
		begin
			mux_sig <= sel_DRTR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b1;
			dram_write <= 1'b0;
			state <= LDAC_IA2;
		end
		
		LDAC_IA2:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_A;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b1;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= LDAC_IA3;
		end
		
		LDAC_IA3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b1;
			dram_write <= 1'b0;
			state <= LDAC_IB2;
		end
		
		LDAC_IB2:
		begin
			mux_sig <= sel_dram;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_B;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b1;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= LDAC_IB3;
		end
		
		LDAC_IB3:
		begin
			mux_sig <= sel_DR;
			load_decode_sig <= load_AC;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b1;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b1;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b1;
			state <= STAC_IC3;
		end
		
		STAC_IC3:
		begin
			mux_sig <= sel_C;
			load_decode_sig <= load_AR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= STAC_IC4;
		end
		
		STAC_IC4:
		begin
			mux_sig <= sel_ACinv;
			load_decode_sig <= load_DR;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_C;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b1;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= FETCH1;
		end
		
		MUL1:
		begin
			mux_sig <= sel_PR;
			load_decode_sig <= load_off;
			alu_sig <= ALU_mul;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b1;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b1;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= FETCH1;
		end
		
		END1:
		begin
			mux_sig <= sel_none;
			load_decode_sig <= load_off;
			alu_sig <= ALU_inactive;
			inc_decode_sig <= inc_off;
			busy_sig <= 1'b0;
			rst_PC <= 1'b0;
			clear_ac <= 1'b0;
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
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
			iram_read <= 1'b0;
			iram_write <= 1'b0;
			dram_read <= 1'b0;
			dram_write <= 1'b0;
			state <= END1;
		end
		
		
		
	endcase
end


endmodule