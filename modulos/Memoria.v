`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2021 09:38:33 PM
// Design Name: 
// Module Name: Memoria
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


module Memoria( // memoria de datos
    output reg [31:0] data_out, // salida de memoria
    input [7:0] address, // direcci�n en memoria
    input [31:0] data_in, // valor para escritura
    input we_byte, // se�ales de control de la UC
    input we_word,
    input out_byte,
    input CLK, // CLK y reset globales
    input reset
);

    wire [1:0] sel; // se�al de control unificada 
    reg [31:0] memory [255:0]; // inicializaci�n de espacio de memoria
    
    initial begin
        $readmemb("Ceros.txt", memory); // llena la memoria con ceros
    end

    assign sel = {we_byte, we_word}; // asigna se�ales de control a sel

    always @ (*) begin // bloque combinacional para la salida
        if (reset) begin
            $readmemb("Ceros.txt", memory); // si reset = 1 pone en cero la memoria y saca cero en la salida
            data_out <= 32'd0;
        end
        else if(out_byte)
            data_out <= {24'd0, memory[address][7:0]}; // asigna un �nico byte de salida seg�n se�al de control
        else
            data_out <= memory[address]; // saca el espacio de memoria completo seg�n la direcci�n
    end
    
    always @ (posedge CLK) begin // bloque secuencial de escritura
        case (sel) // casos seg�n se�ales de control
            2'b10 : 
                memory[address] <= {24'd0, data_in[7:0]}; // escribe un �nico byte en un espacio de memoria 
            2'b01 : 
                memory[address] <= data_in; // escribe un espacio de memoria 
            default : 
                memory[address] <= memory[address]; // la memoria no cambia
        endcase  
    end    
    
endmodule
