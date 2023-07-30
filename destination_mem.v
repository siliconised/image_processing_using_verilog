`timescale 1ns / 1ps

module destination_mem(clk,write,address,in_data,comp,vga_addr,out_data);
input clk,write;
input [17:0] address;
input [7:0]in_data;
input comp;
input [15:0] vga_addr;
output reg [7:0] out_data;

 (* RAM_STYLE="BLOCK" *)
 reg [7:0] store_mem [65535:0];
      
always @ (posedge clk) begin
       if(comp)
            out_data <= store_mem[vga_addr];
       if(write)
            store_mem[address] <= in_data; 
end

endmodule
