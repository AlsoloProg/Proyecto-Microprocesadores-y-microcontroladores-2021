`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2021 11:11:39 PM
// Design Name: 
// Module Name: MemInstru
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


module MemInstru4 (Direccion, B1, B2, B3, B4); // Memoria de instrucciones
    
    input [7:0] Direccion; // entra PC

    reg [7:0] ROMINSTRU [255:0]; // se inicializa la memoria con 128 espacios de 8 bits c/u
    output reg [7:0] B1; // salen los bits más significativos de la instrucción
    output reg [7:0] B2; // salen los siguientes cuatro bits de la instrucción
    output reg [7:0] B3; // salen los siguientes cuatro bits de la instrucción
    output reg [7:0] B4; // salen los bits menos significativos de la instrucción
   
    initial begin
        $readmemb("IfelsegotoBin.txt", ROMINSTRU); // se carga la memoria con el código whilebin
     end

    always @(*) // se asignan las salidas de acuerdo a la dirección en memoria
        begin
            B1 <= ROMINSTRU[Direccion];
            B2 <= ROMINSTRU[Direccion+2'd1];
            B3 <= ROMINSTRU[Direccion+2'd2];
            B4 <= ROMINSTRU[Direccion+2'd3];
        end
endmodule
