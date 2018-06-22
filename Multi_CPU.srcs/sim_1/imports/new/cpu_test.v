`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 13:23:49
// Design Name: 
// Module Name: cpu_test
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


module cpu_test;
    // input
    reg clk;
    reg Reset;
    // output
    wire [31:0] pc;
    wire [31:0] pc4;
    
    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] writeData;
    wire [4:0] writeReg;
    wire [31:0] IRIn;
    wire [31:0] IROut;
    wire [31:0] regA;
    wire [31:0] regB;
    wire [31:0] ALUResult;
    wire [2:0] State;
    wire [31:0] DataOut;
    wire [31:0] ramout;
    
    Multi_CPU M_CPU(
        .clk(clk),
        .Reset(Reset), 
        .pc(pc), 
        .pcIn(pc4), 
        .rs(rs), 
        .rt(rt), 
        .ReadData1(ReadData1), 
        .ReadData2(ReadData2), 
        .ALUResult(ALUResult), 
        .writeData(writeData),
        .writeReg(writeReg),
        .IRIn(IRIn),
        .IROut(IROut),
        .regA(regA),
        .regB(regB),
        .State(State),
        .DataOut(DataOut),
        .ramout(ramout));
    
    
    always #10 clk = !clk;
    initial begin
        clk = 0;
        Reset = 1;
        #10;
        Reset = 0;
        #85;
        Reset = 1;
    end

endmodule
