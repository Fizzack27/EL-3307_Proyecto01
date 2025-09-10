`timescale 1ns/1ps

module tb_modulo_01;

    // Señales de entrada y salida
    logic [3:0] conmutador_4;
    logic [3:0] sindrome_ref;

    // Instancia del DUT (Device Under Test)
    modulo_01 dut (
        .conmutador_4(conmutador_4),
        .sindrome_ref(sindrome_ref)
    );

    // Estímulos
    initial begin
        $display("Tiempo | conmutador_4 | sindrome_ref");
        $display("------------------------------------");

        // Probar todas las combinaciones posibles (16 valores de 4 bits)
        for (int i = 0; i < 16; i++) begin
            conmutador_4 = i;
            #10; // Espera 10 ns para estabilidad
            $display("%4t | %b | %b", $time, conmutador_4, sindrome_ref);
        end

        $finish; // Terminar simulación
    end
    initial begin
        $dumpfile("tb_modulo_01.vcd"); // archivo para GTKWave
        $dumpvars(0, tb_modulo_01);   // guarda todas las señales del testbench
    end

endmodule