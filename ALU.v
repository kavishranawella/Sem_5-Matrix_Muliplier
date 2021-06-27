module ALU (clk, in1, in2, alu_control, out, zflag);

input clk;
input [15:0] in1;
input [15:0] in2;
input [3:0] alu_control;
output reg [15:0] out;
output zflag;

//reg en;

parameter NO_OPERATION=3'b000, MUL=3'b001, ADD=3'b010, SUB=3'b011, DIV=3'b100;

//always @(alu_control[2])
//begin
//	
//	en <= alu_control[2];
//	
//end

always @(posedge clk)
begin

	case(alu_control[2:0])
		NO_OPERATION : out <= out;
		MUL : out <= in1*in2; //multiplication
		ADD : out <= in1+in2; //add
		SUB : 
		begin
			if (in1==in2) out <= 16'b0000000000000000;
			else out <= in1-in2; 
		end
		DIV : out <= in1/in2; //division
		default : out <= 16'bXXXXXXXXXXXXXXXX;
	endcase
	
end 

assign zflag = (out == 16'b0000000000000000) ? 1'b1 : 1'b0; 

endmodule


