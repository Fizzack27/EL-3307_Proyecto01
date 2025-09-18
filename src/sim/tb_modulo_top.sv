`timescale 1ns/1ps

module tb_modulo_top;

    // Entradas
    logic [3:0] conmutador_4;
    logic [7:0] conmutador_8;

    // Salidas
    logic [4:0] led;

    // Instancia del DUT
    modulo_top dut (
        .conmutador_4(conmutador_4),
        .conmutador_8(conmutador_8),
        .led(led)
    );

    // Proceso de estímulos
    initial begin
        $dumpfile("tb_modulo_top.vcd");
        $dumpvars(0, tb_modulo_top);

        $display("Tiempo\tconmutador_4\tconmutador_8\tled");
        // Caso 1: palabra sin error
        conmutador_4 = 4'b1100; // palabra transmitida
        conmutador_8 = 8'b11100001; // misma palabra codificada sin error
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 2: un error en un bit de la palabra recibida
        conmutador_4 = 4'b1100; // palabra transmitida
        conmutador_8 = 8'b11100101; // misma palabra codificada sin error (w0)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 3: un error en un bit de la palabra recibida
        conmutador_4 = 4'b1100; // palabra transmitida
        conmutador_8 = 8'b11110001; // misma palabra codificada sin error (w1)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 4: un error en un bit de la palabra recibida
        conmutador_4 = 4'b1100; // palabra transmitida
        conmutador_8 = 8'b11000001; // misma palabra codificada sin error (w2)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 5: un error en un bit de la palabra recibida
        conmutador_4 = 4'b1100; // palabra transmitida 
        conmutador_8 = 8'b10100001; // misma palabra codificada sin error (w3)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 6: 2 errores 
        conmutador_4 = 4'b1100; // palabra transmitida 
        conmutador_8 = 8'b10000001; // misma palabra codificada sin error (w3 , w2)
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);

        // Caso 7: otra palabra 
        conmutador_4 = 4'b1100; // palabra transmitida 
        conmutador_8 = 8'b11010010; // otra palabra
        #10;
        $display("%0t\t%b\t%b\t%b", $time, conmutador_4, conmutador_8, led);
        $finish;
    end

endmodule
