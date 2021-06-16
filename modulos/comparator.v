`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2021 15:19:30
// Design Name: 
// Module Name: comparator
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


module comparator( // comparador para UC
    input signed [31:0] reg1, // operando de entrada 1
    input signed [31:0] reg2, // operando de entrada 2
    output reg ne, // salida negative
    output reg ge // salida greater equal
    );

    wire resta; // cable interno
    assign resta = (reg1 >= reg2); // resta de operandos 

    always @(*) // asigna bandera ge según resta
        if (resta) 
            ge <= 1'b1; 
        else
            ge <= 1'b0;

    always @(*) // asigna bandera ne según resta
        if (reg1 != reg2)
            ne <= 1'b1;
        else
            ne <= 1'b0;

endmodule