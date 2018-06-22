`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/09 18:45:14
// Design Name: 
// Module Name: ROM
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



module InstructionMemory ( 
    input InsMemRw, 
    input [31:0] addr,
    output reg [31:0] dataOut
    );  
    reg [7:0] rom[127:0]; 
    
    initial begin     
        $readmemb ("D:/CPU/Multi_CPU//data/res.txt", rom);  
    end
    
    always@(InsMemRw or addr) begin  
        if (InsMemRw == 1) begin          
           dataOut[31:24] = rom[addr]; 
           dataOut[23:16] = rom[addr+1]; 
           dataOut[15:8] = rom[addr+2]; 
           dataOut[7:0] = rom[addr+3]; 
        end
    end
endmodule
