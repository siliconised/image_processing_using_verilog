`timescale 1ns / 1ps

module conv(clk,rst,ld,filter,complete,o_red,o_blue,o_green,o_hsync,o_vsync);
input clk,rst,ld;
input [2:0] filter;
output complete;
output [3:0] o_red,o_blue,o_green;
output o_hsync,o_vsync;

wire read,write;
reg i_read,i_write;
wire [17:0] address;
wire [7:0] data_out,in_data;
reg comp;
wire [15:0]vga_addr;
wire [7:0] out_data;
reg [7:0] vga_out;
wire [3:0] red,green,blue;
wire hsync,vsync;

always @(*) begin
    vga_out = out_data;
end

assign complete = comp;
assign o_red = red;
assign o_blue = blue;
assign o_green = green;
assign o_hsync = hsync;
assign o_vsync = vsync;

source_mem sm(clk,read,address,data_out);
destination_mem dm(clk,write,address,in_data,comp,vga_addr,out_data);
vga display(clk,~comp,red,green, blue,hsync,vsync,vga_addr,vga_out);

reg [17:0]addr;
reg [17:0] t_addr,t_write;
reg [7:0] input_data;
reg [8:0] h_counter,v_counter;
assign address = addr;
assign in_data = input_data;
assign read =  i_read;
assign write = i_write;
assign complete = comp;

reg [17:0] conv_data_0,conv_data_1,conv_data_2,conv_data_3,conv_data_4,conv_data_5,conv_data_6,conv_data_7,conv_data_8,conv_data;

localparam RESET   = 'd0,
           ADDRS    = 'd1,
           FETCH_0 = 'd2,
           FETCH_1 = 'd3,
           FETCH_2 = 'd4,
           FETCH_3 = 'd5,
           FETCH_4 = 'd6,
           FETCH_5 = 'd7,
           FETCH_6 = 'd8,
           FETCH_7 = 'd9,
           FETCH_8 = 'd10,
           CONVOLVE_1 = 'd12,
           CONVOLVE_2 = 'd13,
           STORE = 'd14,
           TERMINAL = 'd15;

reg [4:0]state;           
reg [7:0] pixel_0;
reg [7:0] pixel_1;
reg [7:0] pixel_2;
reg [7:0] pixel_3;
reg [7:0] pixel_4;
reg [7:0] pixel_5;
reg [7:0] pixel_6;
reg [7:0] pixel_7;
reg [7:0] pixel_8;

always @(posedge clk) begin
        if(rst) begin
             state <= RESET;
        end
        else begin
              case(state)
                   RESET : begin
                         addr <= 0;
                         i_read <= 1'b1;
                         i_write <= 1'b0;
                         state <= ADDRS;
                         comp <= 1'b0;
                         h_counter <= 0;
                         v_counter <= 0;
                   end
                   ADDRS : begin
                        i_read = 1'b1;
                        t_addr =  v_counter*258 + h_counter;
                        t_write =  v_counter*256 + h_counter;
                        state <= FETCH_0;
                   end
                   FETCH_0 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 0;
                         pixel_0 = data_out;
                         state <= FETCH_1;
                   end
                   FETCH_1 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 1;
                         pixel_1 = data_out;
                         state <= FETCH_2;
                   end
                   FETCH_2 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 2;
                         pixel_2 = data_out;
                         state <= FETCH_3;
                   end
                   FETCH_3 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 258;
                         pixel_3 = data_out;
                         state <= FETCH_4;
                   end
                   FETCH_4 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 259;
                         pixel_4 = data_out;
                         state <= FETCH_5;
                   end
                   FETCH_5 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 300;
                         pixel_5 = data_out;
                         state <= FETCH_6;
                   end
                   FETCH_6 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 516;
                         pixel_6 = data_out;
                         state <= FETCH_7;
                   end
                   FETCH_7 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 517;
                         pixel_7 = data_out;
                         state <= FETCH_8;
                   end
                   FETCH_8 : begin
                         i_read = 1'b1;
                         i_write = 1'b0;
                         addr = t_addr + 518;
                         pixel_8 = data_out;
                         state  = CONVOLVE_1;
                   end
                   CONVOLVE_1 : begin
                         i_write = 1'b0;
                         i_read = 1'b0;
                         //blurr
                         if(filter == 0) begin
                         conv_data_0 = pixel_0/9;
                         conv_data_1 = pixel_1/9;
                         conv_data_2 = pixel_2/9;
                         conv_data_3 = pixel_3/9;
                         conv_data_4 = pixel_4/9;
                         conv_data_5 = pixel_5/9;
                         conv_data_6 = pixel_6/9;
                         conv_data_7 = pixel_7/9;
                         conv_data_8 = pixel_8/9;
                         end
                         //negative
                         else if(filter == 1) begin
                         conv_data_0 = (255 - pixel_0)/9;
                         conv_data_1 = (255 - pixel_1)/9;
                         conv_data_2 = (255 - pixel_2)/9;
                         conv_data_3 = (255 - pixel_3)/9;
                         conv_data_4 = (255 - pixel_4)/9;
                         conv_data_5 = (255 - pixel_5)/9;
                         conv_data_6 = (255 - pixel_6)/9;
                         conv_data_7 = (255 - pixel_7)/9;
                         conv_data_8 = (255 - pixel_8)/9;
                         end
                         //sharpen
                         else if(filter == 2) begin
                         conv_data_0 = 0;
                         conv_data_1 = ~pixel_1+1;
                         conv_data_2 = 0;
                         conv_data_3 = ~pixel_3+1;
                         conv_data_4 = {pixel_4[5:0],2'b00} + 1;
                         conv_data_5 = ~pixel_5 + 1;
                         conv_data_6 = 0;
                         conv_data_7 = ~pixel_7+1;
                         conv_data_8 = 0;
                         end
                         //emboss
                         else if(filter == 3) begin
                         conv_data_0 = ~{pixel_0[6:0],1'b0} + 1;
                         conv_data_1 = ~pixel_1 + 1;
                         conv_data_2 = 0;
                         conv_data_3 = ~pixel_3 + 1;
                         conv_data_4 = pixel_4 ;
                         conv_data_5 = pixel_5;
                         conv_data_6 = 0;
                         conv_data_7 = pixel_7;
                         conv_data_8 = {pixel_8[6:0],1'b0};
                         end
                         //right sobel
                         else if(filter == 4) begin
                         conv_data_0 = ~pixel_0 + 1;
                         conv_data_1 = 0;
                         conv_data_2 = pixel_2;
                         conv_data_3 = ~{pixel_3[6:0],1'b0} + 1;
                         conv_data_4 = 0;
                         conv_data_5 = {pixel_5[6:0],1'b0};
                         conv_data_6 = ~pixel_6+1;
                         conv_data_7 = 0;
                         conv_data_8 = pixel_8;
                         end
                         state = CONVOLVE_2;
                   end
                   CONVOLVE_2 : begin
                         conv_data   = conv_data_0 + conv_data_1 + conv_data_2 + conv_data_3 + conv_data_4 + 
                         conv_data_5 + conv_data_6 + conv_data_7 + conv_data_8;
                         state = STORE;
                   end
                   STORE : begin
                         i_write = 1'b1;
                         if(conv_data[15] == 1)
                             input_data <= 8'b00000000;
                         else if(conv_data >= 255)
                             input_data <= 8'b11111111;
                         else 
                             input_data <= conv_data[7:0];
                             
                         addr = t_write;
                         
                         if(h_counter == 255) begin
                              h_counter = 0;
                              if(v_counter == 255) begin
                                  comp = 1;
                                  state =  TERMINAL;
                              end
                              else begin
                                 v_counter = v_counter + 1;
                                 state =  ADDRS;
                              end
                        end
                         else begin
                              h_counter = h_counter + 1;
                              state =  ADDRS;
                         end
                   end
                   TERMINAL : begin
                         state = TERMINAL;
                         i_read <= 1'b0;
                         i_write <= 1'b0;
                   end
              endcase
        end
end

ila_0 (
clk,


address,
data_out,
in_data,
h_counter,
v_counter,
state
);

endmodule
