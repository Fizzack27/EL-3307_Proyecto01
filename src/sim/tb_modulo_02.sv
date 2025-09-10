`timescale 1ns/1ps

module tb_modulo_02;

    // Señales de prueba
    logic [7:0] conmutador_8;
    logic [3:0] sindrome_detec;

    // Instancia del DUT (Device Under Test)
    modulo_02 dut (
        .conmutador_8(conmutador_8),
        .sindrome_detec(sindrome_detec)
    );

    // Procedimiento de prueba
    initial begin
        $display("==== INICIO DE SIMULACION TESTBENCH modulo_02 ====");
        
        // Caso 1: palabra sin error (ejemplo: 0b01100101)
        conmutador_8 = 8'b00101101; // g0=0, w3=1, w2=1, w1=0, p2=0, w0=1, p1=0, p0=1
        #10;
        $display("Caso 1: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        // Caso 2: error en un bit de datos (ejemplo: bit w2 cambiado)
        conmutador_8 = 8'b00101001; // bit5 alterado
        #10;
        $display("Caso 2: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        // Caso 3: error en un bit de paridad (ejemplo: p1 cambiado)
        conmutador_8 = 8'b00101100; // bit1 alterado
        #10;
        $display("Caso 3: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        // Caso 4: error doble (ejemplo: w0 y p2 cambiados)
        conmutador_8 = 8'b10101001; 
        #10;
        $display("Caso 4: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        // Caso 5: palabra toda en ceros
        conmutador_8 = 8'b00000000; 
        #10;
        $display("Caso 5: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        // Caso 6: palabra toda en unos
        conmutador_8 = 8'b11111111; 
        #10;
        $display("Caso 6: conmutador_8=%b => sindrome=%b", conmutador_8, sindrome_detec);

        $display("==== FIN DE SIMULACION ====");
        $finish;
    end
    initial begin
        $dumpfile("tb_modulo_02.vcd"); // archivo para GTKWave
        $dumpvars(0, tb_modulo_02);   // guarda todas las señales del testbench
    end
endmodule
