module ALU (clk, in1, in2, alu_control, out, zflag, ac_load);

input clk;
input [15:0] in1;
input [15:0] in2;
input [2:0] alu_control;
output reg [15:0] out = 16'b0000000000000000;
output zflag;
output ac_load;

reg pos_sig = 1'b0;
reg neg_sig = 1'b1;
reg [15:0] prev_in1 = 16'b0000000000000000;

//reg en;

parameter NO_OPERATION=3'b000, MUL=3'b001, ADD=3'b010, SUB=3'b011, DIV=3'b100;

always @(posedge clk)
begin

	case(alu_control[2:0])
		NO_OPERATION : 
		begin
			out <= out;
			prev_in1 <= out;
		end
		
		MUL : 						//multiplication
		begin
			out <= in1*in2; 
			prev_in1 <= in1;
		end
		
		ADD : 						//add
		begin
			out <= in1+in2;
			prev_in1 <= in1;		
		end
		
		SUB : 
		begin
			if (in1==in2) out <= 16'b0000000000000000;
			else out <= in1-in2; 
			prev_in1 <= in1;
		end
		
		DIV : 					 //division
		begin
			out <= in1/in2;
			prev_in1 <= in1;
		end
		
		default : 
		begin
			out <= 16'b0000000000000000;
			prev_in1 <= out;
		end
	endcase
	
end 

always @(negedge clk)
begin

	if (prev_in1==out)
		pos_sig <= pos_sig;
	else
		pos_sig <= ~pos_sig;
	
end

always @(posedge clk)
begin

	neg_sig <= ~pos_sig;
	
end

assign ac_load = pos_sig ~^ neg_sig;

assign zflag = (out == 16'b0000000000000000) ? 1'b1 : 1'b0; 

endmodule


