`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2021 21:44:17
// Design Name: 
// Module Name: ALU
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


module ALU (input signed [31:0] Op1, Op2, input [3:0] ALU_Control, output [31:0] ALU_Out ); // unidad aritmético lógica

    reg signed [32:0] ALU_Result; // registro para la salida
    wire [31:0] Op11; // operando de entrada 1
    assign Op11 = Op1;
    wire [31:0] Op22; // operando de entrada 2
    assign Op22 = Op2; 
    assign ALU_Out = ALU_Result[31:0]; // asigna salida
    
    always @(*) begin
        case(ALU_Control)
            4'b0000: // Suma
                ALU_Result= Op1 + Op2;
            4'b0001: // Resta
                ALU_Result = Op1 - Op2;
            4'b0010: // AND
                ALU_Result = Op1 & Op2;
            4'b0011: // OR
                ALU_Result = Op1 | Op2;
            4'b0100: // XOR
                ALU_Result = Op1 ^ Op2;
            4'b0101: // XNOR
                ALU_Result = ~(Op1 ^ Op2);
            4'b0110: // NAND
                ALU_Result = ~(Op1 & Op2);
            4'b0111: // NOR
                ALU_Result = ~(Op1 | Op2);
            4'b1000: // Logical Shift Left
                ALU_Result = Op1 << Op2;    
            4'b1001: // Logical Shift Right
                ALU_Result = Op1 >> Op2;
            4'b1010: // Arithmetic Shift Right
                ALU_Result = Op1 >>> Op2;    
            default: ALU_Result = Op1 + Op2;
        endcase
    end

endmodule
