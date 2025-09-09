// Calculo de la posicion del error, se comparan los sindromes
module moduleName #(
    input [3:0] sindrome_ref, // Sindrome palabra de referencia
    input [3:0] sindorme_detec, // Sindrome palabra recibida
    // Orden Sindrome
    //  3|  2|  1|  0|  # bits
    // g0| s2| s1| s0|
    // g1| c2| c1| c0| 
    output [3:0] pos_error; // posicion en binario del error
);
    // Se compara los bits de los sindromes y se obtiene la posicion del error
    // Orden Error
    //  3|  2|  1|  0| # bits
    // eg| e2| e1| e0|

    assign pos_error = {
        sindrome_ref[3] ^ sindorme_detec[3], // g0 ^ g1
        sindrome_ref[2] ^ sindorme_detec[2], // s2 ^ c2
        sindrome_ref[1] ^ sindorme_detec[1], // s1 ^ c1
        sindrome_ref[0] ^ sindorme_detec[0]  // s0 ^ c0
    }
endmodule