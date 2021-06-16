`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2021 06:05:34 PM
// Design Name: 
// Module Name: UC
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

module UC ( input [6:0] UC1, UC3, input [2:0] UC2, input ne, ge, Reset, output reg [3:0] ALUControl, output reg [2:0] ExtendControl, MemOutControl, output reg [1:0] MuxDMCon, output reg PCSrc, MuxRs1Con, MuxRs2Con, RegWirte, ReturnDir );
    
    // unidad de control
    // entradas UC1, UC2 y UC3 de la instrucción
    // banderas ne y ge del comparador
    // reset global
    // salidas de control para cada módulo del datapath
    
    always @ (*) // bloque combinacional para asignar señales de control
        if (Reset) begin  // default de señales de control ante reset
            ALUControl <= 4'b0000;
            ExtendControl <= 3'b000;
            MemOutControl <= 3'b000;
            MuxDMCon <= 2'b00;
            PCSrc <= 1'b1;
            MuxRs1Con <= 1'b0;
            MuxRs2Con <= 1'b0;
            RegWirte <= 1'b0;
            ReturnDir <= 1'b0;
        end else begin
            case(UC3) // asignación de señales de control según el OPCode
                7'b0110011 : begin 
                    if (UC2[0])
                        ALUControl <= 4'b1000;
                    else if (UC1)
                        ALUControl <= 4'b0001; /////////////////////////////////////////////////
                    else
                        ALUControl <= 4'b0000;
                    ExtendControl <= 3'b000;
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b01;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b0;
                    RegWirte <= 1'b1;
                    ReturnDir <= 1'b1;
                end
                7'b0010011 : begin 
                    if (UC2 == 3'd0) begin
                        ALUControl <= 4'b0000;
                        ExtendControl <= 3'b000; 
                    end
                    else if (UC2 == 3'd7) begin
                        ALUControl <= 4'b0010;
                        ExtendControl <= 3'b000; 
                    end
                    else if (UC2 == 3'd1) begin
                        ALUControl <= 4'b1000;
                        ExtendControl <= 3'b010; 
                    end
                    else if (UC2 == 3'd5) begin
                        ALUControl <= 4'b1010;
                        ExtendControl <= 3'b010; 
                    end
                    else begin
                        ALUControl <= 4'b0100;
                        ExtendControl <= 3'b000; 
                    end
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b01;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b1;
                    ReturnDir <= 1'b1;
                end 
                7'b1100111 : begin 
                    ALUControl <= 4'b0000;
                    ExtendControl <= 3'b001;
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b11; ///////////////
                    PCSrc <= 1'b0;
                    MuxRs1Con <= 1'b0; 
                    MuxRs2Con <= 1'b0; ///////////////
                    RegWirte <= 1'b1;
                    ReturnDir <= 1'b0;
                end 
                7'b1100011 : begin 
                    ALUControl <= 4'b0010;
                    ExtendControl <= 3'b110;
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b10;
                    MuxRs1Con <= 1'b1;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b0;
                    ReturnDir <= 1'b0;
                    if (UC2 == 3'd5 && ge == 1'b1) ////
                       PCSrc <= 1'b0;
                    else if (UC2 == 3'd1 && ne == 1'b1)
                       PCSrc <= 1'b0;
                    else
                       PCSrc <= 1'b1;
                end  
                7'b1101111 : begin 
                    ALUControl <= 4'b0000;
                    ExtendControl <= 3'b101;
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b10;
                    PCSrc <= 1'b0;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b1; //////
                    ReturnDir <= 1'b0;
                end 
                7'b0000011 : begin 
                    ALUControl <= 4'b0000;
                    ExtendControl <= 3'b000; 
                    if (UC2[2])
                        MemOutControl <= 3'b001;
                    else 
                        MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b00;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b1;
                    ReturnDir <= 1'b1;
                end 
                7'b0110111 : begin 
                    ALUControl <= 4'b0010;
                    ExtendControl <= 3'b100;
                    MemOutControl <= 3'b000;
                    MuxDMCon <= 2'b01;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b1;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b1;
                    ReturnDir <= 1'b1;
                end 
                7'b0100011 : begin 
                    ALUControl <= 4'b0000;
                    ExtendControl <= 3'b011;
                    if (UC2[1])
                        MemOutControl <= 3'b010;
                    else
                        MemOutControl <= 3'b100;
                    MuxDMCon <= 2'b00;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b1;
                    RegWirte <= 1'b0;
                    ReturnDir <= 1'b0;
                end  
                default : begin 
                    ALUControl <= 4'b0000;
                    ExtendControl <= 3'b000;
                    MemOutControl <= 3'b000; 
                    MuxDMCon <= 2'b00;
                    PCSrc <= 1'b1;
                    MuxRs1Con <= 1'b0;
                    MuxRs2Con <= 1'b0;
                    RegWirte <= 1'b0;
                    ReturnDir <= 1'b0;
                end  
            endcase
            
            // cada caso de OPCode tiene condicionales para diferenciar entre instrucciones y lograr el control óptimo
            
        end
endmodule
