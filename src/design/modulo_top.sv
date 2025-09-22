module modulo_top (
    // Palabras
    input logic clk,
    input logic rst_n,
    input logic [3:0] conmutador_4,
    input logic [7:0] conmutador_8,
    // Leds
    output logic [4:0] led,
    output logic [6:0] seven,
    output logic [1:0] anodo
);
    // Variables
    logic [3:0] sindrome_ref;
    logic [3:0] sindrome_detec;
    logic [3:0] pos_error;
    logic [4:0] w_corregida_b4;
    logic [6:0] seven_error;

    // Modulos
    modulo_01 codificador (
        .conmutador_4 (conmutador_4),
        .sindrome_ref (sindrome_ref)
    );
    modulo_02 receptor (
        .conmutador_8 (conmutador_8),
        .sindrome_detec (sindrome_detec)
    );
    modulo_03 comparador (
        .sindrome_ref (sindrome_ref),
        .sindrome_detec (sindrome_detec),
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
    modulo_07 #(.REFRESH_DIV(27000)) disp_mux (
    .clk           (clk),
    .rst_n         (rst_n),
    .w_corregida_b4(w_corregida_b4),
    .error_pos     (pos_error),
    .anodo         (anodo),
    .seven         (seven)
    );

endmodule