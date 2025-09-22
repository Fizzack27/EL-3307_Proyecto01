// Corrige la palabra segun la posicion del error
module modulo_04 (
    input [7:0] conmutador_8, // Palabra recibida 
    input [3:0] pos_error, // Posicion del error 
    output [4:0] w_corregida_b4 // Palabra corregida de 4 bits + bit extra en caso de 2 errores
);
    logic [7:0] palabra;
    logic [7:0] mascara_error;
    logic [2:0] error_bit;

    // Se guarda la posicion del error sin el bit global 
    assign error_bit = {
        pos_error[2],
        pos_error[1],
        pos_error[0]
    };

    // Se crea una mascara de error para definir el tipo de error: Ignora caso bit global
    assign mascara_error = (pos_error == 4'b0000) ? 8'b00000000 : // 0 errores
                           ((pos_error != 4'b0000) && (pos_error[3] == 1'b1)) ? (8'b00000001 << (error_bit - 1)): // error en error_bit
                            8'b01111111; // 2 errores

    // Se corrige la palabra recibida
    assign palabra = (mascara_error == 8'b01111111) ? 8'b10000000 : conmutador_8 ^ mascara_error;

    // Se obtienen los bits de informacion y se informa si hay 2 errores 
    assign w_corregida_b4[4] = (mascara_error == 8'b01111111) ? 1'b1 : 1'b0; // 1 = 2 errores
    assign w_corregida_b4[3] = palabra[6]; // bit de error: 1 = error
    assign w_corregida_b4[2] = palabra[5];
    assign w_corregida_b4[1] = palabra[4];
    assign w_corregida_b4[0] = palabra[2];
endmodule

// Orden 
//  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 | # bits
// g0 | w3 | w2 | w1 | p2 | w0 | p1 | p0 | palabra recibida
//                   | eg | e2 | e1 | e0 | pos_error 
//                        | e2 | e1 | e0 | error_bit
//              |  e | w3 | w2 | w1 | w0 | w_corregida_b4 