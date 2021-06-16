`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:21:51 11/25/2020
// Design Name:   main
// Module Name:   D:/TransmisorMorse/main_tb.v
// Project Name:  TransmisorMorse
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_tb;

	// Inputs
	reg Reset;
	reg Clock;
	reg [2:0] cod;

	// Outputs
	wire [31:0] GPIO;

    //Dump de memoria
    integer i, df1, df2, df3, df4, df5;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.Reset(Reset), 
		.CLK(Clock),
		.GPIO(GPIO),
		.cod(cod)
	);

	initial begin
		// Initialize Inputs
		Reset = 1;
		Clock = 1;
		cod = 3'b000;

		// Wait 100 ns for global reset to finish
		#500000;
		Reset = 0;
		
		#100000000
		df1 = $fopen("dp1.txt", "w");
		$fwrite(df1, "Dirección en Memoria | Valor\n");
		$fwrite(df1, "______________|___________\n");
		$fwrite(df1, "0x%h    |0x%h\n",32'hABCD , GPIO);
		for(i=0; i<256; i=i+1) begin
		  $fwrite(df1, "______________|___________\n");
		  $fwrite(df1, "0x%h    |0x%h\n",i , uut.mem_datos.memory[i]);
		end
		$fclose(df1);
		
		#500000;
		Reset = 1; 
		cod = 3'b001;
		
		#500000;
		Reset = 0;
		
        #100000000
		df2 = $fopen("dp2.txt", "w");
		$fwrite(df2, "Dirección en Memoria | Valor\n");
		$fwrite(df2, "______________|___________\n");
		$fwrite(df2, "0x%h    |0x%h\n",32'hABCD , GPIO);
		for(i=0; i<256; i=i+1) begin
		  $fwrite(df2, "______________|___________\n");
		  $fwrite(df2, "0x%h    |0x%h\n",i , uut.mem_datos.memory[i]);
		end
		$fclose(df2);
		
		#500000;
		Reset = 1; 
		cod = 3'b010;
		
		#500000;
		Reset = 0;
		
		#100000000
		df3 = $fopen("dp3.txt", "w");
		$fwrite(df3, "Dirección en Memoria | Valor\n");
		$fwrite(df3, "______________|___________\n");
		$fwrite(df3, "0x%h    |0x%h\n",32'hABCD , GPIO);
		for(i=0; i<256; i=i+1) begin
		  $fwrite(df3, "______________|___________\n");
		  $fwrite(df3, "0x%h    |0x%h\n",i , uut.mem_datos.memory[i]);
		end
		$fclose(df3);
		
		#500000;
		Reset = 1; 
		cod = 3'b011;
		
		#500000;
		Reset = 0;
		
		#100000000
		df4 = $fopen("dp4.txt", "w");
		$fwrite(df4, "Dirección en Memoria | Valor\n");
		$fwrite(df4, "______________|___________\n");
		$fwrite(df4, "0x%h    |0x%h\n",32'hABCD , GPIO);
		for(i=0; i<256; i=i+1) begin
		  $fwrite(df4, "______________|___________\n");
		  $fwrite(df4, "0x%h    |0x%h\n",i , uut.mem_datos.memory[i]);
		end
		$fclose(df4);
		
		#500000;
		Reset = 1; 
		cod = 3'b100;
		
		#500000;
		Reset = 0;
		
		#100000000
		df5 = $fopen("dp5.txt", "w");
		$fwrite(df5, "Dirección en Memoria | Valor\n");
		$fwrite(df5, "______________|___________\n");
		$fwrite(df5, "0x%h    |0x%h\n",32'hABCD , GPIO);
		for(i=0; i<256; i=i+1) begin
		  $fwrite(df5, "______________|___________\n");
		  $fwrite(df5, "0x%h    |0x%h\n",i , uut.mem_datos.memory[i]);
		end
		$fclose(df5);
	end
    always #250000 Clock = ~Clock;   
   
endmodule


