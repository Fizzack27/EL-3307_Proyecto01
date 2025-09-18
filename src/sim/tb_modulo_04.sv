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
        conmutador_8 = 8'b11100001; // palabra de ejemplo
        pos_error = 4'b0000;        // 0 errores
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 2: Error w0
        conmutador_8 = 8'b11100101;
        pos_error = 4'b1011;
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 3: Error w1
        conmutador_8 = 8'b11110001;
        pos_error = 4'b1101;
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 4: Error w2
        conmutador_8 = 8'b11000001;
        pos_error = 4'b1110;
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);
        
        // Caso 5: Error w3
        conmutador_8 = 8'b10100001;
        pos_error = 4'b1111;
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);

        // Caso 4: 2 Errores
        conmutador_8 = 8'b10000001;
        pos_error = 4'b0001;
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_8, pos_error, w_corregida_b4);
        // Finalizar simulación
        $finish;
    end
        initial begin
        $dumpfile("tb_modulo_04.vcd"); // archivo para GTKWave
        $dumpvars(0, tb_modulo_04);   // guarda todas las señales del testbench
    end
endmodule
