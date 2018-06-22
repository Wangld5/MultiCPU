`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 15:40:11
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK,
    input Reset,
    input [31:0] PCIn,
    input PCWre,
    output [31:0] PCOut,
    output [31:0] PC4
    );
    reg [31:0] pc;
    reg resetPc;
    assign PCOut = pc;
    assign PC4 = pc + 4;
    
    
    always@(negedge CLK or negedge Reset) begin
        if (Reset == 0) begin
          pc = 32'h00000000;
          resetPc = 1;
        end
        else if(PCWre == 1) begin
          if(resetPc == 1) begin
            pc = 32'h00000000;
            resetPc = 0;
          end
          else begin
            pc <= PCIn;
          end
        end
    end
endmodule
