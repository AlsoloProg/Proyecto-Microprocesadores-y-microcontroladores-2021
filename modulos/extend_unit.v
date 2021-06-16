`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2021 21:55:10
// Design Name: 
// Module Name: extend_unit
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


module extend_unit( // unidad extensora
    input [2:0] sel, // selección del tipo de extensión
    input [11:0] mux2, // entrada 1
    input [4:0] mux3, // entrada 2
    input [11:0] mux4, // entrada 3
    input [19:0] mux5, // entrada 4
    input [19:0] mux6, // entrada 5
    input [11:0] mux7, // entrada 6
    output [31:0] extended // salida extendida
    );

    // distintas entradas son combinaciones que simplifican extensiones
    
    // se inicializan registros internos
    reg [31:0] mux1Ext; 
    reg [31:0] mux2Ext;
    wire [31:0] mux3Ext;
    reg [31:0] mux4Ext;
    wire [31:0] mux5Ext;
    reg [31:0] mux6Ext;
    reg [31:0] mux7Ext;

    reg [20:0] mux6shifted;
    reg [12:0] mux7shifted;

    assign mux5Ext = {mux5, 12'b0}; // extension para LUI
    assign mux3Ext = {27'b0, mux3}; // extensión sin signo

    always @(*) // extensión con signo y enmascara último a 0 
        if (mux2[11] == 1) begin 
            mux2Ext <= {20'b11111111111111111111, mux2};
            mux1Ext <= {20'b11111111111111111111, mux2};
            mux2Ext[0] <= 1'b0;
        end
        else begin
            mux2Ext <= {20'b00000000000000000000, mux2};
            mux1Ext <= {20'b00000000000000000000, mux2};
            mux2Ext[0] <= 1'b0;
        end

    always @(*) // extensión con signo 
        if (mux4[11] == 1) begin
            mux4Ext <= {20'b11111111111111111111, mux4};
        end
        else begin
            mux4Ext <= {20'b00000000000000000000, mux4};
        end

    // multiplicación con 2
    always @(*) 
        mux6shifted = mux6 << 1'b1;

    always @(*) 
        mux7shifted = mux7 << 1'b1;
   
    always @(*) // extensión con signo de inmediatos desplazados
        if (mux7shifted[12] == 1) begin
            mux7Ext <= {19'b1111111111111111111, mux7shifted};
        end
        else begin
            mux7Ext <= {19'b0000000000000000000, mux7shifted};
        end

    always @(*) // extensión con signo de inmediatos desplazados
        if (mux6shifted[20] == 1) begin
            mux6Ext <= {11'b11111111111, mux6shifted};
        end
        else begin
            mux6Ext <= {11'b00000000000, mux6shifted};
        end

    reg [31:0] muxOut;

    always @(*) // asigna las salidas
        case (sel)
         3'b000:  muxOut = mux1Ext;
         3'b001:  muxOut = mux2Ext;
         3'b010:  muxOut = mux3Ext;
         3'b011:  muxOut = mux4Ext;
         3'b100:  muxOut = mux5Ext;
         3'b101:  muxOut = mux6Ext;
         3'b110:  muxOut = mux7Ext;
         default: muxOut = 32'b0;
        endcase
      
    assign extended = muxOut; // salida
	
endmodule

