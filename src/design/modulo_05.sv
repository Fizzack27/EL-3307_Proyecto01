// Enciende los leds de la fpga, no enciende ninguno si hay 2 errores
module modulo_05 (
    input logic [4:0] w_corregida_b4,
    output logic [4:0] led
);
    assign led = ~w_corregida_b4; // se encienden los leds

endmodule