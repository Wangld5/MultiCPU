`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:44:54
// Design Name: 
// Module Name: DM
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


module DataMemory(
    input [31:0] Address,
    input [31:0] DataIn, 
    input mRD, 
    input mWR, 
    output [31:0] DataOut,
    output [31:0] ramout
    );
    reg [7:0] ram [0:60]; 
    integer i;
    initial begin
      for (i = 0;i<60 ;i=i+1 ) begin
        ram[i] = 0;
      end
    end
    
    wire RD;
    wire WR;

    assign RD = mRD==1? 0 : 1;
    assign WR = mWR==1? 0 : 1; 

    assign DataOut[7:0] = (RD == 0)?ram[Address + 3]:8'bz; 
    assign DataOut[15:8] = (RD == 0)?ram[Address + 2]:8'bz;
    assign DataOut[23:16] = (RD == 0)?ram[Address + 1]:8'bz;
    assign DataOut[31:24] = (RD == 0)?ram[Address ]:8'bz;
    

    always@(WR) begin
        if(WR == 0) begin
            ram[Address] <= DataIn[31:24];
            ram[Address+1] <= DataIn[23:16];
            ram[Address+2] <= DataIn[15:8];
            ram[Address+3] <= DataIn[7:0];
        end
    end

    assign ramout[7:0] = ram[Address+3];
    assign ramout[15:8] = ram[Address+2];
    assign ramout[23:16] = ram[Address+1];
    assign ramout[31:24] = ram[Address];
endmodule