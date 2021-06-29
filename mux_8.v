module mux_8 (in0, in1, in2, in3, sel, out); 

input [7:0] in0; 
input [7:0] in1;
input [7:0] in2;
input [7:0] in3; 
input [1:0] sel;
output reg [7:0] out;

	always @(sel or in0 or in1 or in2 or in3)
	begin
		case (sel)
			2'b00  : out <= in0;
			2'b01  : out <= in1;
			2'b10  : out <= in2;
			2'b11  : out <= in3;
			default : out <= 8'bXXXXXXXX; 
		endcase
	end

endmodule
