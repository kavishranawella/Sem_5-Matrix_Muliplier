module decoder_3to8 (in_sig, out_sig); 

 
input [2:0] in_sig;
output reg [6:0] out_sig;

	always @(in_sig)
	begin
		case (in_sig)
			3'b000  : out_sig <= 7'b0000000;
			3'b001  : out_sig <= 7'b0000001;
			3'b010  : out_sig <= 7'b0000010;
			3'b011  : out_sig <= 7'b0000100;
			3'b100  : out_sig <= 7'b0001000;
			3'b101  : out_sig <= 7'b0010000;
			3'b110  : out_sig <= 7'b0100000;
			3'b111  : out_sig <= 7'b1000000;
			default : out_sig <= 7'b0000000; 
		endcase
	end

endmodule
