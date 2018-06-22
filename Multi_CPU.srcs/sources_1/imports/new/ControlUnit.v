`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/15 15:54:01
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input[5:0] Op,
    input Zero,
    input Sign,
    input Reset,
    input CLK,
    output PCWre, // 0 PC������
    output ALUSrcA, // 0 - ���ԼĴ����ѣ� 1 - ������λ��sa
    output ALUSrcB, // 0 - ���ԼĴ����ѣ� 1 - ����sign��zero��չ��������
    output RegWre, //  0 - ��д�Ĵ���ָ� 1 - д�Ĵ���
    output DBDataSrc, // 0 - ����ALU������� 1 - �������ݴ洢�������
    output WrRegDSrc, //
    output InsMemRw, // 0 - дָ��Ĵ����� 1 - ��ָ��Ĵ���
    output mRD, // 0 - �������̬�� 1 - �����ݼĴ���
    output mWR, // 0 - �޲����� 1 - д���ݼĴ���
    output IRWre, // 1 - IR�Ĵ���дʹ��
    output ExtSel, //  0 - ������0��չ�� 1 - ������������չ
    output reg [1:0] PCSrc,
    output reg [1:0] RegDst, // 0 - ����rt�� 1 - ����rs
    output reg [2:0] ALUOp,
    output reg[2:0] State
    );
    
    parameter [2:0] If = 3'b000, id = 3'b001, exe = 3'b010, wb = 3'b011, mem = 3'b100;
    always@(posedge CLK) begin
        if (Reset == 0) State = If;
        else begin
            case(State)
                If: State = id;
                id: begin
                    if (Op[5:3] == 3'b111) State = If;
                    else State = exe;
                end
                exe: begin
                    if (Op[5:2] == 4'b1101) State = If;
                    else if (Op[5:2] == 4'b1100) State = mem;
                    else State = wb;
                end
                wb: State = If;
                mem: begin
                    if (Op[0] == 0) State = If;
                    else State = wb;
                end
            endcase
        end
    end

    assign PCWre = Op == 6'b111111 || State != 3'b000 ? 0 : 1;
    assign ALUSrcA = Op == 6'b011000 ? 1 : 0;
    assign ALUSrcB = (Op == 6'b000010 || Op == 6'b010010 || Op == 6'b100111 || Op[5:2] == 4'b1100) ? 1 : 0;
    assign DBDataSrc = Op == 6'b110001 ? 1 : 0;
    assign RegWre = (Op == 6'b111111 || Op == 6'b110000 || Op[5:1] == 5'b11100 || Op[5:2] == 4'b1101 || (State != 3'b011 && Op != 6'b111010)) ? 0 : 1;
    assign WrRegDSrc = Op == 6'b111010 ? 0 : 1;
    assign InsMemRw = State == 3'b000 ? 1 : 0;
    assign mRD = (Op == 6'b110001 && State == 3'b100) ? 1 : 0;
    assign mWR = (Op == 6'b110000 && State == 3'b100) ? 1 : 0;
    assign IRWre = State == 3'b000 ? 1 : 0;
    assign ExtSel = (Op == 6'b010010 || Op == 6'b100111) ? 0 : 1;
    
    always@(Op or Zero or Sign) begin
        case(Op)
            6'b000000: begin // add
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b000;
            end
            6'b000001: begin // sub
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b001;
            end
            6'b000010: begin // addi
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b000;
            end
            6'b010000: begin // or
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b101;
            end
            6'b010001: begin // and
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b110;
            end
            6'b010010: begin // ori
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b101;
            end
            6'b011000: begin // sll
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b100;
            end
            6'b100110: begin // slt
                PCSrc = 2'b00;
                RegDst = 2'b10;
                ALUOp = 3'b011;
            end
            6'b100111: begin // sltiu
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b010;
            end
            6'b110000: begin // sw
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b110001: begin // lw
                PCSrc = 2'b00;
                RegDst = 2'b01;
                ALUOp = 3'b000;
            end
            6'b110100: begin // beq
                PCSrc = Zero == 0 ? 2'b00 : 2'b01;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b110110: begin // bltz
                PCSrc = (Zero == 1 || Sign == 0) ? 2'b00 : 2'b01;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b111000: begin // j
                PCSrc = 2'b11;
                RegDst = 2'b00;
                ALUOp = 3'b001;
            end
            6'b111001: begin // jr
                PCSrc = 2'b10;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b111010: begin // jal
                PCSrc =2'b11;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            6'b111111: begin // halt
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
            default: begin
                PCSrc = 2'b00;
                RegDst = 2'b00;
                ALUOp = 3'b000;
            end
        endcase
    end
    
endmodule
