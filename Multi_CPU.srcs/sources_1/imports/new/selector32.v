`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 20:24:17
// Design Name: 
// Module Name: IR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module selector32(
    input [4:0] rt,
    input [4:0] rd,
    input [1:0] RegDst,
    output reg [4:0] out
    );
    always@(*) begin
      case (RegDst)
        2'b00: out = 5'b11111;
        2'b01: out = rt;
        2'b10: out = rd; 
        default: out = 0;
      endcase
    end
endmodule
