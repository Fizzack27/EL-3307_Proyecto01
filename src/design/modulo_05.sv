// Enciende los leds de la fpga, no enciende ninguno si hay 2 errores
module modulo_05 (
    input logic [4:0] w_corregida_b4,
    output logic [3:0] leds;
);
    logic [3:0] bits_info;
    assign bits_info = {w_corregida_b4[2], w_corregida_b4[1], w_corregida_b4[0]} // se obtiene solo la informacion de la palabra
    assign leds = (w_corregida_b4[3] == 1'b1) ? 4'b111 : ~bits_info; // se encienden los leds
endmodule