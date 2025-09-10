`timescale 1ns/1ps

module tb_modulo_04;

    // Entradas del DUT
    logic [7:0] conmutador_8;
    logic [3:0] pos_error;

    // Salidas del DUT
    logic [4:0] w_corregida_b4;

    // Instanciación del DUT
    modulo_04 dut (
        .conmutador_8(conmutador_8),
        .pos_error(pos_error),
        .w_corregida_b4(w_corregida_b4)
    );

    initial begin
        // Inicialización
        $display("Tiempo\tconmutador_8\tpos_error\tw_corregida_b4");

        // Caso 1: Sin error
        conmutador_8 = 8'b11010010; // palabra de ejemplo
        pos_error = 4'b1000;        // 0 errores
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 2: Error en bit global (bit 7)
        conmutador_8 = 8'b01010010;
        pos_error = 4'b1000;        // error en bit global
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 3: Error único en bit 6 (w3)
        conmutador_8 = 8'b11010110;
        pos_error = 4'b1011;        // error en bit 6
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 4: Dos errores
        conmutador_8 = 8'b11011110;
        pos_error = 4'b0111;        // dos errores (simulación)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Finalizar simulación
        $stop;
    end
        initial begin
        $dumpfile("tb_modulo_04.vcd"); // archivo para GTKWave
        $dumpvars(0, tb_modulo_04);   // guarda todas las señales del testbench
    end
endmodule
