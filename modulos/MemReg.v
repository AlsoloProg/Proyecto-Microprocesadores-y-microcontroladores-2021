`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2021 09:42:41 PM
// Design Name: 
// Module Name: mem_reg
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

module MemReg ( input [5:0] R1, R2, RD, input [31:0] WRD, input clk, reset, Wreg, output reg [31:0] s1, s2 ); // memoria de registros
    
    // entradas clk y reset
    // entrada de control Wreg para escritura
    // selección de registros de salida R1 y R2
    //selección de registro de escritura RD
    //palabra a escribir WRD
    // registros de salida s1 y s2
    
    reg [31:0] RAM [32:0]; // se inicializa el espacio de registros
    
    initial begin
        $readmemb("Zeros.txt", RAM); // se cargan los registros con cero para evitar que estén indefinidos siempre
    end
    
    always @ (*) // bloque combinacional para asaignar las salidas s1 y s2
        if (reset) begin
            $readmemb("Zeros.txt", RAM); // con el reset los registros vuelven a cero
            s1 <= 32'd0; // con reset sale 0
            s2 <= 32'd0;
        end
        else begin
            s1 <= RAM [R1]; // si no hay reset sale el registro que apunta R1
            s2 <= RAM [R2]; // sale el registro que apunta R2
        end
        
    always @ (posedge clk) // bloque secuencial para escritura
        if (RD == 6'd0)
            RAM [RD] <= 32'd0; // si se escribe el registro 0 siempre se escribe con cero por arquitectura
        else if (Wreg) 
            RAM[RD] <= WRD; // se escribe registro RD con WRD si Wreg = 1
        else
            RAM[RD] <= RAM[RD]; // los registros no se escriben cuando Wreg = 0
        
endmodule