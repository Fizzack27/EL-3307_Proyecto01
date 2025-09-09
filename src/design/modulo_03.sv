module moduleName #(
    // Sindrome palabra de referencia
    input [3:0] sindrome_ref, // s2 | s1 | s0 | g0
    // Sindrome palabra recibida
    input [3:0] sindorme_detec, // c2 | c1 | c0 | g1
    output [3:0] pos_error; // posicion en binario del error
);
    // Se compara los bits de los sindromes
    // se obtiene la posicion del error
    assing pos_error = {
        sindrome_ref[3] ^ sindorme_detec[3], // s2 ^ c2
        sindrome_ref[2] ^ sindorme_detec[2], // s1 ^ c1
        sindrome_ref[1] ^ sindorme_detec[1], // s0 ^ c0
        sindrome_ref[0] ^ sindorme_detec[0]  // g0 ^ g1
    }
endmodule