module modulo_top (
    // Palabras
    input logic [3:0] conmutador_4,
    input logic [7:0] conmutador_8,
    // Leds
    output logic [4:0] led
);
    // Variables
    logic [3:0] sindrome_ref;
    logic [3:0] sindrome_detec;
    logic [3:0] pos_error;
    logic [4:0] w_corregida_b4;

    // Modulos
    modulo_01 codificador (
        .conmutador_4 (conmutador_4),
        .sindrome_ref (sindrome_ref)
    );
    modulo_02 receptor (
        .conmutador_8 (conmutador_8),
        .sindorme_detec (sindrome_detec)
    );
    modulo_03 comparador (
        .sindrome_ref (sindrome_ref),
        .sindorme_detec (sindrome_detec),
        .pos_error (pos_error)
    );
    modulo_04 corrector (
        .conmutador_8 (conmutador_8),
        .pos_error (pos_error),
        .w_corregida_b4 (w_corregida_b4)
    );
    modulo_05 pintar_palabra (
        .w_corregida_b4 (w_corregida_b4),
        .led (led)
    );
endmodule