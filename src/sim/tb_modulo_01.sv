`timescale 1ns/1ps

module tb_modulo_01;

  // Estímulo y observación
  logic [3:0] conmutador_4;   // -> entrada del DUT
  logic [7:0] hamming;   // <- salida del DUT

  // Instancia del DUT (tal cual tu encabezado)
  modulo_01 dut (
    .conmutador_4 (conmutador_4),
    .hamming (hamming)
  );

  // Barrido 0..15
  initial begin
    // (Opcional) VCD para GTKWave
    $dumpfile("tb_modulo_01.vcd");
    $dumpvars(0, tb_modulo_01);

    // Recorrer todas las combinaciones de 4 bits
    for (int i = 0; i < 16; i++) begin
      conmutador_4 = i[3:0];
      #2; // tiempo de asentamiento
      $display("[%0t] in=%02d (b=%04b) -> hamming=%0h (b=%04b)",
               $time, i, conmutador_4, hamming, hamming);
    end

    $display(">>> Barrido completo (0..15).");
    $finish;
  end

endmodule
