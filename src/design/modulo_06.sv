module modulo_06 (
    input  logic [4:0] w_corregida_b4,
    output logic [6:0] seven // a b c d e f g (ACTIVO-BAJO)
);
    // decodificador bin -> HEX -> 7 segmentos (ACTIVO-BAJO)
    always_comb begin
        // por defecto: todo apagado
        seven = 7'b1111111;
        case (w_corregida_b4)
            5'b00000: seven = 7'b0000001; // 0
            5'b00001: seven = 7'b1001111; // 1
            5'b00010: seven = 7'b0010010; // 2
            5'b00011: seven = 7'b0000110; // 3
            5'b00100: seven = 7'b1001100; // 4
            5'b00101: seven = 7'b0100100; // 5 
            5'b00110: seven = 7'b0100000; // 6 
            5'b00111: seven = 7'b0001111; // 7
            5'b01000: seven = 7'b0000000; // 8
            5'b01001: seven = 7'b0000100; // 9
            5'b01010: seven = 7'b0001000; // A
            5'b01011: seven = 7'b1100000; // b
            5'b01100: seven = 7'b0110001; // C
            5'b01101: seven = 7'b1000010; // d
            5'b01110: seven = 7'b0110000; // E
            5'b01111: seven = 7'b0111000; // F
            5'b10000: seven = 7'b1111110; // 2 errores
            default: seven = 7'b1111111; // apagado
        endcase
    end
endmodule
