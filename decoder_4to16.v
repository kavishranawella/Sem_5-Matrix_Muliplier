module decoder_4to16 (in_sig, out_sig); 

 
input [3:0] in_sig;
output reg [12:0] out_sig;

	always @(in_sig)
	begin
		case (in_sig)
			4'b0000  : out_sig <= 13'b0000000000000;
			4'b0001  : out_sig <= 13'b0000000000001;
			4'b0010  : out_sig <= 13'b0000000000010;
			4'b0011  : out_sig <= 13'b0000000000100;
			4'b0100  : out_sig <= 13'b0000000001000;
			4'b0101  : out_sig <= 13'b0000000010000;
			4'b0110  : out_sig <= 13'b0000000100000;
			4'b0111  : out_sig <= 13'b0000001000000;
			4'b1000  : out_sig <= 13'b0000010000000;
			4'b1001  : out_sig <= 13'b0000100000000;
			4'b1010  : out_sig <= 13'b0001000000000;
			4'b1011  : out_sig <= 13'b0010000000000;
			4'b1100  : out_sig <= 13'b0100000000000;
			4'b1101  : out_sig <= 13'b1000000000000;
			default  : out_sig <= 13'b0000000000000; 
		endcase
	end

endmodule
