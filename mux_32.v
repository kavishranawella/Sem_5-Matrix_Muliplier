module mux_32 (in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, 
							in10, in11, in12, in13, in14, in15, in16, in17, 
							in18, in19, in20, in21, in22, in23, in24, in25, 
							in26, in27, in28, in29, in30, in31, sel, out); 

input [15:0] in0; 
input [15:0] in1;
input [15:0] in2;
input [15:0] in3; 
input [15:0] in4; 
input [15:0] in5;
input [15:0] in6;
input [15:0] in7;
input [15:0] in8; 
input [15:0] in9;
input [15:0] in10;
input [15:0] in11;
input [15:0] in12; 
input [15:0] in13;
input [15:0] in14;
input [15:0] in15;
input [15:0] in16; 
input [15:0] in17;
input [15:0] in18;
input [15:0] in19; 
input [15:0] in20; 
input [15:0] in21;
input [15:0] in22;
input [15:0] in23;
input [15:0] in24; 
input [15:0] in25;
input [15:0] in26;
input [15:0] in27;
input [15:0] in28; 
input [15:0] in29;
input [15:0] in30;
input [15:0] in31;
input [4:0] sel;
output reg [15:0] out;

	always @(sel or in0 or in1 or in2 or 
					in3 or in4 or in5 or in6 or 
						in7 or in8 or in9 or in10 or 
							in11 or in12 or in13 or in14 or 
								in15 or in16 or in17 or in18 or 
									in19 or in20 or in21 or in22 or 
										in23 or in24 or in25 or in26 or 
											in27 or in28 or in29 or in30 or in31)
	begin
		case (sel)
			5'b00000  : out <= in0;
			5'b00001  : out <= in1;
			5'b00010  : out <= in2;
			5'b00011  : out <= in3;
			5'b00100  : out <= in4;
			5'b00101  : out <= in5;
			5'b00110  : out <= in6;
			5'b00111  : out <= in7;
			5'b01000  : out <= in8;
			5'b01001  : out <= in9;
			5'b01010  : out <= in10;
			5'b01011  : out <= in11;
			5'b01100  : out <= in12;
			5'b01101  : out <= in13;
			5'b01110  : out <= in14;
			5'b01111  : out <= in15;
			5'b10000  : out <= in16;
			5'b10001  : out <= in17;
			5'b10010  : out <= in18;
			5'b10011  : out <= in19;
			5'b10100  : out <= in20;
			5'b10101  : out <= in21;
			5'b10110  : out <= in22;
			5'b10111  : out <= in23;
			5'b11000  : out <= in24;
			5'b11001  : out <= in25;
			5'b11010  : out <= in26;
			5'b11011  : out <= in27;
			5'b11100  : out <= in28;
			5'b11101  : out <= in29;
			5'b11110  : out <= in30;
			5'b11111  : out <= in31;
			default : out <= 16'bXXXXXXXXXXXXXXXX; 
		endcase
	end

endmodule
