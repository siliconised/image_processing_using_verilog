`timescale 1ns / 1ps

module tb();
reg clk,rst,ld;
reg [2:0] filter;
wire complete;
wire [3:0] o_red,o_blue,o_green;
wire o_hsync,o_vsync;

conv uut(clk,rst,ld,filter,complete,o_red,o_blue,o_green,o_hsync,o_vsync);


initial begin
     clk <= 1'b0;
end

always 
     #5 clk <= ~clk;

initial begin
    #10  rst = 1'b1; ld = 1'b1; filter = 3'b001;
    #200 rst = 1'b0; ld = 1'b0;
    #10 $stop;
end


endmodule
