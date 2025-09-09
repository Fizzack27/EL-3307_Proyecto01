// Detecta la palabra recibida y calcula el sindrome de esta
module modulo_02(
    input logic [7:0] conmutador_8, // Palabra recibida conmutador 8
    output logic [3:0] sindrome_detec, // Sindrome palabra recibida
);
    // Se hace una copia de la palabra recibida (wr) por el conmutador 8
    //      7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 | # bits
    //     g0 | w3 | w2 | w1 | p2 | w0 | p1 | p0 |
    logic wr0, wr1, wr2, wr3, wr4, wr5, wr6, wr7;
    // copia de bits de la palabra recibida para simplicar sintaxis 
    assign wr7 = conmutador_8[7]; // g0
    assign wr6 = conmutador_8[6]; // w3
    assign wr5 = conmutador_8[5]; // w2
    assign wr4 = conmutador_8[4]; // w1
    assign wr3 = conmutador_8[3]; // p2
    assign wr2 = conmutador_8[2]; // w0
    assign wr1 = conmutador_8[1]; // p1
    assign wr0 = conmutador_8[0]; // p0
    
    // Se calcula el sindrome de la palabra recibida
    logic c0, c1, c2, g1;
    assign c0 = wr0 ^ wr2 ^ wr4 ^ wr6; // p0 ^ w0 ^ w1 ^ w3
    assign c1 = wr1 ^ wr2 ^ wr5 ^ wr6; // p1 ^ w0 ^ w2 ^ w3
    assign c2 = wr3 ^ wr4 ^ wr5 ^ wr6; // p2 ^ w1 ^ w2 ^ w3
    assign g1 = wr0 ^ wr1 ^ wr2 ^ wr3 ^ wr4 ^ wr5 ^ wr6; // p0 ^ p1 ^ w0 ^ p2 ^ w1 ^ w2 ^ w3

    // Orden Sindrome
    //  3|  2|  1|  0| # bits
    // g0| s2| s1| s0|
    assign sindrome_detec = {g1, c2, c1, c0};

endmodule