`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2021 08:42:38 AM
// Design Name: 
// Module Name: main
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

module main(input Reset, CLK, input [2:0] cod, output reg [31:0] GPIO ); // modulo main para interconección de componentes

   
    // cables para interconectar los modulos  
    wire [31:0] PC, RG1, RG2, IMMALU, ALU1, ALU2, ALUSalida, DatamemOut, SumaJal, MuxGrande, WRD, PCMC ;
    wire [24:0] IMM;
    reg [7:0] I1, I2, I3, I4;
    wire [7:0] I11, I12, I13, I14, I21, I22, I23, I24, I31, I32, I33, I34, I41, I42, I43, I44, I51, I52, I53, I54;
    reg [7:0] MAX;
    wire [6:0] UC1, UC3;
    wire [5:0] R1, R2, RD;
    wire [3:0] ALUCntrl;
    wire [2:0] UC2, ExtCntrl, MemOutCntrl;
    wire [1:0] MxDMCN;
    wire ReturnDir, PCSrc, MxRs1Cn, MxRs2Cn, RegWrite, ne, ge, enable;
    reg en;
    
    assign PCMC = PC + 32'd4; // calcula PC + 4

    always @ (*) // asigna variable que establece el largo de cada código
        case (cod)
            3'd0: MAX <= 8'd92;
            3'd1: MAX <= 8'd56;
            3'd2: MAX <= 8'd100;
            3'd3: MAX <= 8'd148;
            3'd4: MAX <= 8'd180;
            default: MAX <= 8'd0;
        endcase

    always @ (posedge CLK) // señal de control para evitar que el código se encicle y poder ver la salida en la simulación
        if (Reset)
            en <= 1'b1;
        else if (PC == MAX)
            en <= 1'b0;
        else
            en <= en;

    assign enable = en;

    contador cont ( // modulo contador
        .CLK(CLK),
        .en(enable),
        .Reset(Reset),
        .PCSrc(PCSrc),
        .PCMC(PCMC),
        .MuxGrande(MuxGrande),
        .cod(cod[2]),
        .PC(PC)
        );
        
        
    // modulos de memorias de instrucciones para los cinco códigos
    MemInstru instruc_mem (
        .Direccion(PC[6:0]),
        .B1(I11),
        .B2(I12),
        .B3(I13),
        .B4(I14)
        );
      
     MemInstru2 instruc_mem2 (
        .Direccion(PC[5:0]),
        .B1(I21),
        .B2(I22),
        .B3(I23),
        .B4(I24)
        );
        
     MemInstru3 instruc_mem3 (
        .Direccion(PC[6:0]),
        .B1(I31),
        .B2(I32),
        .B3(I33),
        .B4(I34)
        );
        
      MemInstru4 instruc_mem4 (
        .Direccion(PC[7:0]),
        .B1(I41),
        .B2(I42),
        .B3(I43),
        .B4(I44)
        );
        
      MemInstru5 instruc_mem5 (
        .Direccion(PC[7:0]),
        .B1(I51),
        .B2(I52),
        .B3(I53),
        .B4(I54)
        );  
      
      always @ (*) // seleccionador de memoria de instrucciones para facilitar verificación
        case (cod)
            3'd0: begin
                I1 <= I11;
                I2 <= I12;
                I3 <= I13;
                I4 <= I14;
            end
            3'd1: begin
                I1 <= I21;
                I2 <= I22;
                I3 <= I23;
                I4 <= I24;
            end
            3'd2: begin
                I1 <= I31;
                I2 <= I32;
                I3 <= I33;
                I4 <= I34;
            end
            3'd3: begin
                I1 <= I41;
                I2 <= I42;
                I3 <= I43;
                I4 <= I44;
            end
            3'd4: begin
                I1 <= I51;
                I2 <= I52;
                I3 <= I53;
                I4 <= I54;
            end
            default: begin
                I1 <= I11;
                I2 <= I12;
                I3 <= I13;
                I4 <= I14;
            end
        endcase
     
    // asigna señales para distintos modulos
    assign R1 = {I2[3:0], I3[7]}; 
    assign R2 = {I1[0], I2[7:4]};
    assign RD = {I3[3:0], I4[7]};
    assign IMM = {I1, I2, I3, I4[7]};
    assign UC1 = I1[7:1];
    assign UC2 = I3[6:4];
    assign UC3 = I4[6:0];
    
    assign WRD = ReturnDir ? MuxGrande : PCMC; // mux para saber que escribir en mem de registros
    
    MemReg register_mem ( // modulo de memoria de registros
        .clk(CLK),
        .reset(Reset),
        .R1(R1),
        .R2(R2),
        .RD(RD),
        .WRD(WRD),
        .Wreg(RegWrite),
        .s1(RG1), 
        .s2(RG2)
        );
        
    extend_unit unidad_ext ( // modulo de unidad extensora
        .sel(ExtCntrl), 
        .mux2(IMM[24:13]),
        .mux3(IMM[17:13]),
        .mux4({IMM[24:18], IMM[4:0]}),
        .mux5(IMM[24:5]),
        .mux6({IMM[24], IMM[12:5], IMM[13], IMM[23:14]}),
        .mux7({IMM[24], IMM[0], IMM[23:18], IMM[4:1]}),
        .extended(IMMALU)
        );
        
    // muxes para elegir los operandos de entrada a la ALU
    assign ALU1 = MxRs1Cn ? 32'hffffffff : RG1;
    assign ALU2 = MxRs2Cn ? IMMALU : RG2;
    
    ALU alu ( // modulo de la ALU
        .Op1(ALU1),
        .Op2(ALU2),
        .ALU_Control(ALUCntrl), 
        .ALU_Out(ALUSalida)
        );
    
    comparator comp ( // modulo comparador para banderas
        .reg1(RG1),
        .reg2(RG2),
        .ne(ne), 
        .ge(ge)
        );

    Memoria mem_datos ( // modulo de memoria de datos
        .reset(Reset),
        .data_out(DatamemOut),
        .address(ALUSalida[7:0]),
        .data_in(RG2), 
        .we_byte(MemOutCntrl[2]), 
        .we_word(MemOutCntrl[1]), 
        .out_byte(MemOutCntrl[0]),
        .CLK(CLK)
        );
     
    assign SumaJal = ALUSalida + PC; // sumador extra para instrucción JAL
    
    Mux4x1 Multiplexor ( // modulo mux grande 
        .SEL(MxDMCN), 
        .A(DatamemOut),
        .B(ALUSalida),
        .C(SumaJal),
        .D({ALUSalida[31:1], 1'b0}),
        .Salida(MuxGrande)
        );
    
    UC control_unit ( // modulo de la unidad de control
        .UC1(UC1), 
        .UC2(UC2), 
        .UC3(UC3),
        .ne(ne),
        .ge(ge),
        .Reset(Reset),
        .ExtendControl(ExtCntrl), 
        .MemOutControl(MemOutCntrl), 
        .MuxDMCon(MxDMCN), 
        .PCSrc(PCSrc), 
        .ALUControl(ALUCntrl),
        .MuxRs1Con(MxRs1Cn), 
        .MuxRs2Con(MxRs2Cn), 
        .RegWirte(RegWrite),
        .ReturnDir(ReturnDir)
        );
    
    always @ (posedge CLK) // asigna salida global GPIO según reset y el address de la memoria de instrucciones
       if (Reset)
           GPIO <= 32'd0;
       else if (ALUSalida == 32'hABCD)
           GPIO <= RG2; 
       else 
           GPIO <= GPIO;
           
endmodule
