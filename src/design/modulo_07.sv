module modulo_07 
#(
    parameter int REFRESH_DIV = 27000
)
(
    input  logic clk,
    input  logic rst_n, // reset activo-bajo, SINCRÓNICO

    input  logic [4:0]  w_corregida_b4,
    input  logic [3:0]  error_pos,

    output logic [1:0]  anodo,
    output logic [6:0]  seven 
);
    // 1) Divisor de refresco (reset síncrono)
    localparam int CNT_W = (REFRESH_DIV <= 1) ? 1 : $clog2(REFRESH_DIV);
    logic [CNT_W-1:0] cnt, cnt_next;
    logic             sel, sel_next;   // 0: dígito 0; 1: dígito 1
    wire              tick = (cnt == REFRESH_DIV-1);

    assign cnt_next = tick ? '0        : (cnt + 1'b1);
    assign sel_next = tick ? ~sel      :  sel;

    // Reset síncrono activo-bajo, (ternario):
    always_ff @(posedge clk) begin
        {cnt, sel} <= rst_n ? {cnt_next, sel_next}
                            : { {CNT_W{1'b0}}, 1'b0 };
    end

    // Dos instancias de tu decodificador (bin -> hexa -> 7 segmentos)
    logic [6:0] seven_w; // para w_corregida_b4
    logic [6:0] seven_e; // para error_pos

    modulo_06 u_hex_w (
        .w_corregida_b4 (w_corregida_b4),
        .seven          (seven_w)
    );

    logic [4:0] error_bit_before;
    logic [4:0] error_bit;
    assign error_bit_before = (w_corregida_b4 == 5'b10000) || (error_pos == 4'b0000) ? 5'b10000: {
        1'b0,
        1'b0,
        error_pos[2],
        error_pos[1],
        error_pos[0]
    }; // analiza si hay dos errores, caso contrario muestra la posicion del bit

    assign error_bit = (error_bit_before == 5'b10000 ) || (error_bit_before == 5'b00000) ? error_bit_before: error_bit_before - 5'b00001; 

    modulo_06 u_hex_e (
        .w_corregida_b4 (error_bit),
        .seven          (seven_e)
    );

    // 3) Multiplex activo-bajo
    // sel=0 -> anodo=2'b10 (enciende dígito 0), seven_w
    // sel=1 -> anodo=2'b01 (enciende dígito 1), seven_e
    assign anodo = sel ? 2'b01 : 2'b10;
    assign seven = sel ? seven_e : seven_w;
endmodule
