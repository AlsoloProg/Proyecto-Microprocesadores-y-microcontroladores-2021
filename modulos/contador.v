`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2021 11:58:36 PM
// Design Name: 
// Module Name: contador
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


module contador( input CLK, Reset, PCSrc, cod, en, input [31:0] PCMC, MuxGrande, output reg [31:0] PC ); // modulo para manejar el contador del programa (PC)

// entra el CLK, reset, la señal de control PCSrc
// cod dice si se trabaja functarray y enable evita que los códigos se enciclen
// PCMC y MuxGrande entran para actualizar el PC
// sale la dirección de instrucción PC
    
    always @ (posedge CLK) begin // espera al ciclo de reloj para aumentar la dirección de la memoria de instrucciones
        if (Reset) // pregunta por la señal global de reset
            if (cod) // indica que se trabaja el código functarray
                PC <= 32'd112; // pone al PC en la dirección del main de functarray
            else
                PC <= 32'd0; // pone al PC en 0 para todos los demas codigos
        else if (en)   // si en=1 el contador funciona
            if(PCSrc == 1 ) // señal de control para ver como se actualiza PC
                PC <= PCMC; // PC = PC + 4
            else if (PCSrc == 0 ) 
                PC <= MuxGrande; // PC hace un salto 
            else
                PC <= PC; // PC no avanza 
    end

endmodule
