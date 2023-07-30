`timescale 1ns / 1ps

module vga(
	input clk,
	input reset,
	
	output reg [3:0] red,
	output reg [3:0] green,
	output reg [3:0] blue,
	output reg	 hsync,
	output reg	 vsync,
	output [15:0]vga_addr,
	input [7:0] vga_out
	
    );

parameter hpixels = 12'd800;
parameter vlines = 12'd521;
parameter hbp = 12'd144;
parameter hfp = 12'd784;
parameter vbp = 12'd31;
parameter vfp = 12'd511;
parameter W = 256;
parameter H = 256;
wire [10:0] C1, R1;

reg [11:0] hc_new;
reg [9:0] hc;
reg [9:0] vc;
reg vidon;
reg spriteon;
reg vsenable;

always @ (posedge clk)
	if (reset || vsenable)	hc_new <= 0;
	else					hc_new <= hc_new + 1;

always@* hc = hc_new[11:2];
			
always@* vsenable = hc == hpixels - 1;
	
always @* hsync = hc > (127);

always @ (posedge clk)
	if (reset || vc_clr)	vc <= 0;
	else if (vsenable)		vc <= vc + 1;

assign vc_clr = vsenable & (vc == vlines - 1);

always@* vsync = vc > 2;

always @(*) vidon = ((hc < hfp) && (hc > hbp) && (vc < vfp) && (vc > vbp));



assign C1 = 11'd100;
assign R1 = 11'd100;


always @(*) spriteon = ((hc >= C1 + hbp) && (hc < C1 + hbp + W) && (vc >= R1 + vbp) && (vc < R1 + vbp + H));


always @(*)
	begin
		red = 0;
		green = 0;
		blue = 0;
		if ((spriteon == 1) && (vidon == 1))
			begin
				red 	= vga_out[7:4];
				green 	= vga_out[7:4];
				blue	= vga_out[7:4];
			end
	end
reg [17:0] addr_cnt;

always@(posedge clk)
	if(reset)	
		addr_cnt <= 0;
	else if((spriteon == 1) && (vidon == 1))
		addr_cnt <= addr_cnt + 1;

assign vga_addr = 	addr_cnt[17:2];
endmodule

