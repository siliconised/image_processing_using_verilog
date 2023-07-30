`timescale 1ns / 1ps

module source_mem(clk,read,address,data_out);
input clk,read;
input [17:0] address;
output reg [7:0] data_out;

 (* RAM_STYLE="BLOCK" *)
 reg [7:0] data_mem [66563:0];
 
 initial
      $readmemb("peppers.mem", data_mem);
 
 always @(posedge clk) begin
       if(read) 
           data_out <= data_mem[address]; 
 end
endmodule