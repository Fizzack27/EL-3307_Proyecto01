// Recibe palabra y calcula los bits de paridad. Salida: Sindrome
module modulo_01 (
    input logic [3:0] conmutador_4, // Palabra obtenida del comutador 4
    
    output logic [3:0] sindorme_ref // Sindrome de la palabra de referencia
);
    logic w0, w1, w2, w3; // Indice de bits de la palabra (word)
    assing {w0, w1, w2, w3} = Comutador_4; // Asignacion de los indice de bits

    // Se calcula la paridad de los bits (p) y global (g0) paridad con todos los datos de la palabra codificada 
    logic p0, p1, p2, g0;
    assing p0 = w0 ^ w1 ^ w3;
    assing p1 = w0 ^ w2 ^ w3;
    assing p2 = w1 ^ w2 ^ w3;
    assing g0 = p0 ^ p1 ^ w0 ^ p2 ^ w1 ^ w2 ^ w3;

    // orden hamming
    //  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 | # bits
    // p0 | p1 | w0 | p2 | w1 | w2 | w3 | g0 |
    logic [7:0] hamming;
    assing hamming = {p0, p1, w0, p2, w1, w2, w3, g0}

    // Calculo del sindrome de la paralabra
    logic s0, s1, s2;
    assing s0 = p0 ^ w0 ^ w1 ^ w3;
    assing s1 = p1 ^ w0 ^ w2 ^ w3;
    assing s2 = p2 ^ w1 ^ w2 ^ w3;
    assing sindorme_ref = {g0, s2, s1, s0};

endmodule