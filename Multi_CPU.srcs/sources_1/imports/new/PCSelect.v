`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:44:32
// Design Name: 
// Module Name: PCSelect
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


module PCSelect(
    input [1:0] PCSrc,
    input [31:0] PC4,
    input [31:0] ExtendOut,
    input [25:0] Address,
    input [31:0] RegData,
    output reg [31:0] PC
    );

    wire [27:0] leftMove;
    assign leftMove = Address << 2;
    always@(PCSrc or PC4 or ExtendOut or Address or RegData) begin
       case(PCSrc)
            2'b00: PC = PC4;
            2'b01: PC = PC4 + (ExtendOut << 2);
            2'b10: PC = RegData;
            2'b11: begin
                PC[31:28] = PC4[31:28];
                PC[27:2] = leftMove[27:2];
                PC[1:0] = 0;
            end
            default: PC = PC4;
       endcase
    end
endmodule
