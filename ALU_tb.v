`timescale 1ns / 1ps

module ALU_tb;

reg clk;
reg [15:0] in1;
reg [15:0] in2;
reg [2:0] alu_control;
wire [15:0] out;
wire zflag;
wire ac_load;

parameter clock_cycle  = 10;

ALU ALU_inst(.clk(clk), .in1(in1), .in2(in2), .alu_control(alu_control), .out(out), .zflag(zflag), .ac_load(ac_load));

initial begin
    clk = 1'b0;
    in1 = 16'd0;
    in2 = 16'd0;
    alu_control = 3'd0;
    #20;
    in1 = 16'd5;
    in2 = 16'd7;
    #20;
    alu_control = 3'd1;
    #20;
    in1 = 16'd3;
    in2 = 16'd10;
    #20;
    alu_control = 3'd2;
    // #20;
    // in1 = 16'd5;
    // in2 = 16'd2;
    // #20;
    // alu_control = 3'd5;
    #60;
    $stop;
end

always #(clock_cycle/2) clk = ~clk;

endmodule