module mux_16_4inputs (in0, in1, in2, in3, sel, out); 

input [15:0] in0; 
input [15:0] in1;
input [15:0] in2;
input [15:0] in3;  
input [3:0] sel;
output reg [15:0] out;

	always @(sel or in0 or in1 or in2 or in3 )
	begin
		case (sel)
			2'b00  : out <= in0;
			2'b01  : out <= in1;
			2'b10  : out <= in2;
			2'b11  : out <= in3;
			default : out <= 16'bXXXXXXXXXXXXXXXX; 
		endcase
	end

endmodule 