// Detecta la palabra recibida y calcula el sindrome de esta
module modulo_02(
    input logic [7:0] conmutador_8,
    output logic [3:0] sindorme_detec,
    output logic [7:0] w_recibida;
);
    // Se hace una copia de la palabra recibida (wr) por el conmutador 8
    //     p0 | p1 | w0 | p2 | w1 | w2 | w3 | g0 |
    logic wr0, wr1, wr2, wr3, wr4, wr5, wr6, wr7;
    // copia de bits de la palabra recibida
    assing wr0 = conmutador_8[0]; // p0
    assing wr1 = conmutador_8[1]; // p1
    assing wr2 = conmutador_8[2]; // w0
    assing wr3 = conmutador_8[3]; // p2
    assing wr4 = conmutador_8[4]; // w1
    assing wr5 = conmutador_8[5]; // w2
    assing wr6 = conmutador_8[6]; // w3
    assing wr7 = conmutador_8[7]; // g0
    assing w_recibida = {wr0, wr1, wr2, wr3, wr4, wr5, wr6, wr7}; // copia de la palabra recibida

    // Se calcula el sindrome de la palabra recibida
    logic c0, c1, c2, g1;
    assing c0 = wr0 ^ wr2 ^ wr4 ^ wr6; // p0 ^ w0 ^ w1 ^ w3
    assing c1 = wr1 ^ wr2 ^ wr5 ^ wr6; // p1 ^ w0 ^ w2 ^ w3
    assing c2 = wr3 ^ wr4 ^ wr5 ^ wr6; // p2 ^ w1 ^ w2 ^ w3
    assing g1 = wr0 ^ wr1 ^ wr2 ^ wr3 ^ wr4 ^ wr5 ^ wr6; // p0 ^ p1 ^ w0 ^ p2 ^ w1 ^ w2 ^ w3
    assing sindorme_detec = {g1, s2, s1, s0};

endmodule