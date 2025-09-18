`timescale 1ns/1ps

module tb_modulo_03;

    // Entradas
    logic [3:0] sindrome_ref;
    logic [3:0] sindrome_detec;

    // Salida
    logic [3:0] pos_error;

    // Instanciación del DUT (Device Under Test)
    modulo_03 dut (
        .sindrome_ref(sindrome_ref),
        .sindrome_detec(sindrome_detec),
        .pos_error(pos_error)
    );

    // Procedimiento de prueba
    initial begin
        $display("==== INICIO SIMULACION modulo_03 ====");
        $display("Tiempo | sind_ref | sind_det | pos_error");

        // Caso 1: Palabra sin errores (síndromes iguales)
        sindrome_ref   = 4'b1000;  
        sindrome_detec = 4'b1000;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        // Caso 2: Error en bit w0
        sindrome_ref   = 4'b1000;
        sindrome_detec = 4'b0011;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        // Caso 3: Error en bit w1
        sindrome_ref   = 4'b1000;
        sindrome_detec = 4'b0101;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        // Caso 4: Error en bit w2
        sindrome_ref   = 4'b1000;
        sindrome_detec = 4'b0110;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        // Caso 5: Error en bit w3
        sindrome_ref   = 4'b1000;
        sindrome_detec = 4'b0111;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        // Caso 6: Comparación con 2 errores 
        sindrome_ref   = 4'b1000;
        sindrome_detec = 4'b1001;  
        #10 $display("%4t   | %b   | %b   | %b", $time, sindrome_ref, sindrome_detec, pos_error);

        $display("==== FIN SIMULACION modulo_03 ====");
        $finish;
    end
    initial begin
        $dumpfile("tb_modulo_03.vcd"); // archivo para GTKWave
        $dumpvars(0, tb_modulo_03);   // guarda todas las señales del testbench
    end
endmodule
