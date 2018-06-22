`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/13 20:32:59
// Design Name: 
// Module Name: S_CPU
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


module Multi_CPU(clk,Reset, pc, pcIn, rs, rt, ReadData1, ReadData2, regA, regB, ALUResult, writeData, writeReg, IRIn, IROut, State, DataOut,ramout);
    input clk;
    input Reset; 
    output [2:0] State;

    // PC
    output [31:0] pc;
    wire [31:0] pc4;
    output [31:0] pcIn;

    // InstDecode
    wire [5:0] op;
    output [4:0] rs;
    output [4:0] rt;
    wire [4:0] rd;
    wire [4:0] sa;
    wire [15:0] immediate;
    wire [25:0] address;

    // Control
    wire PCWre; 
    wire ALUSrcA; 
    wire ALUSrcB; 
    wire DBDataSrc; 
    wire RegWre; 
    wire WrRegDSrc;
    wire InsMemRw; 
    wire mRD; 
    wire mWR; 
    wire IRWre;
    wire ExtSel; 
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;
    
    // DM
    output [31:0] DataOut;
    output [31:0] ramout;

    // RegFile
    output [4:0] writeReg;
    output [31:0] ReadData1;
    output [31:0] ReadData2;
    output [31:0] writeData;

    // Sign, zero extend
    wire [31:0] ExtendOut;

    // ALU
    output [31:0] regA;
    output [31:0] regB;
    output [31:0] ALUResult;
    wire ALUZero;
    wire ALUSign;
    
    // IR
    output [31:0] IRIn;
    output [31:0] IROut;
    
    // DR
    wire [31:0] ADROut;
    wire [31:0] BDROut;
    wire [31:0] ALUOutDROut;
    wire [31:0] DBDRIn;
    wire [31:0] DBDROut;
    
    
    // ALU
    assign regA = ALUSrcA == 0 ? ADROut : sa;
    assign regB = ALUSrcB == 0 ? BDROut : ExtendOut;
    
    // RegFile
    selector32 selReg(.rt(rt), .rd(rd), .RegDst(RegDst), .out(writeReg));
    selector5 selData(.A(pc4), .B(DBDROut), .select(WrRegDSrc), .out(writeData));
        
    // DM
    selector5 selDB(.A(ALUResult), .B(DataOut), .select(DBDataSrc), .out(DBDRIn));

    IR IR(
        .CLK(clk),
        .IRWre(IRWre),
        .InsIn(IRIn),
        .InsOut(IROut)
    );
    
    DR ADR(
        .CLK(clk),
        .DRIn(ReadData1),
        .DROut(ADROut)
    );

    DR BDR(
        .CLK(clk),
        .DRIn(ReadData2),
        .DROut(BDROut)
    );
    
    DR ALUOutDR(
        .CLK(clk),
        .DRIn(ALUResult),
        .DROut(ALUOutDROut)
    );
    
    DR DBDR(
        .CLK(clk),
        .DRIn(DBDRIn),
        .DROut(DBDROut)
    );
    
    
    InstDecode InstDecode( 
        .inst(IROut),
        .op(op),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sa(sa),
        .immediate(immediate),
        .address(address));
        
    PCSelect PCSelect(
        .PCSrc(PCSrc),
        .PC4(pc4),
        .ExtendOut(ExtendOut),
        .Address(address),
        .RegData(ReadData1),
        .PC(pcIn));

    Extend Extend(
        .ExtSel(ExtSel),
        .Data(immediate),
        .ExtendOut(ExtendOut));

    RegFile RegFile(
        .CLK(clk),
        .RST(Reset),
        .RegWre(RegWre),
        .ReadReg1(rs),
        .ReadReg2(rt),
        .WriteReg(writeReg),
        .WriteData(writeData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2));

    ALU ALU(
        .ALUOpcode(ALUOp),
        .regA(regA),
        .regB(regB),
        .result(ALUResult),
        .zero(ALUZero),
        .sign(ALUSign));

    PC PC( 
        .CLK(clk),
        .Reset(Reset),
        .PCWre(PCWre),
        .PCIn(pcIn),
        .PCOut(pc),
        .PC4(pc4));

    InstructionMemory IM( 
        .InsMemRw(InsMemRw),
        .addr(pc),
        .dataOut(IRIn));

    ControlUnit ControlUnit(
        .CLK(clk),
        .Zero(ALUZero),
        .Reset(Reset),
        .Sign(ALUSign),
        .Op(op),
        .PCWre(PCWre), 
        .ALUSrcA(ALUSrcA), 
        .ALUSrcB(ALUSrcB), 
        .DBDataSrc(DBDataSrc), 
        .RegWre(RegWre), 
        .WrRegDSrc(WrRegDSrc),
        .InsMemRw(InsMemRw), 
        .mRD(mRD), 
        .mWR(mWR), 
        .IRWre(IRWre),
        .ExtSel(ExtSel), 
        .PCSrc(PCSrc),
        .RegDst(RegDst), 
        .ALUOp(ALUOp),
        .State(State)
        );

    DataMemory DM(
        .Address(ALUOutDROut),
        .DataIn(BDROut), 
        .mRD(mRD), 
        .mWR(mWR), 
        .DataOut(DataOut),
        .ramout(ramout));

endmodule
