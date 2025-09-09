// Recibe palabra y calcula los bits de paridad. Salida: Sindrome
module modulo_01 (
    input logic [3:0] conmutador_4, // Palabra obtenida del comutador 4
    
    output logic [3:0] sindrome_ref // Sindrome de la palabra de referencia
);
    logic w0, w1, w2, w3; // Indice de bits de la palabra (word)
    assign {w0, w1, w2, w3} = Comutador_4; // Asignacion de los indice de bits

    // Se calcula la paridad de los bits (p) y global (g0) paridad con todos los datos de la palabra codificada 
    logic p0, p1, p2, g0;
    assign p0 = w0 ^ w1 ^ w3;
    assign p1 = w0 ^ w2 ^ w3;
    assign p2 = w1 ^ w2 ^ w3;
    assign g0 = p0 ^ p1 ^ w0 ^ p2 ^ w1 ^ w2 ^ w3;

    // Orden Hamming
    //  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 | # bits
    // g0 | w3 | w2 | w1 | p2 | w0 | p1 | p0 |
    logic [7:0] hamming;
    assign hamming = {g0, w3, w2, w1, p2, w0, p1, p0}

    // Calculo del sindrome de la paralabra
    logic s0, s1, s2;
    assign s0 = p0 ^ w0 ^ w1 ^ w3;
    assign s1 = p1 ^ w0 ^ w2 ^ w3;
    assign s2 = p2 ^ w1 ^ w2 ^ w3;

    // Orden Sindrome
    //  3|  2|  1|  0| # bits
    // g0| s2| s1| s0|
    assign sindrome_ref = {g0, s2, s1, s0};

endmodule