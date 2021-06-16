`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2021 04:52:18 PM
// Design Name: 
// Module Name: Mux4x1
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


module Mux4x1(input [1:0] SEL, input [31:0] A, B, C, D, output reg [31:0] Salida); // multiplexor grande

    // entra el seleccionador para la salida SEL
    // entran operandos A, B, C, D
    // Salida según SEL

    always @ (*) // asigna la salida según SEL
        case (SEL)
            2'b00: Salida <= A;
            2'b01: Salida <= B;
            2'b10: Salida <= C;
            2'b11: Salida <= D;
        endcase
        
endmodule
