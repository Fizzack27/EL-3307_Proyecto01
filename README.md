# Proyecto corto I: Diseño digital combinacional en dispositivos programables

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] David Medina. Video tutorial para principiantes. Flujo abierto para TangNano 9k. Jul. de 2024. url:
https://www.youtube.com/watch?v=AKO-SaOM7BA.

[2] David Medina. Wiki tutorial sobre el uso de la TangNano 9k y el flujo abierto de herramientas. Mayo de
2024. url: https://github.com/DJosueMM/open_source_fpga_environment/wiki

[4] razavi b. (2013) fundamentals of microelectronics. segunda edición. john wiley & sons

## 3. Desarrollo

### 3.0 Descripción general del sistema

El circuito implementa un sistema digital de transmisión y recepción de datos con detección y corrección de errores, basado en el código Hamming extendido (SECDED: Single Error Correction, Double Error Detection).
El sistema se organiza en 7 grandes bloques:

1) Codificador (palabra correcta)
Entrada: una palabra binaria de 4 bits, seleccionada mediante interruptores de 4 switch [W3, W2, W1, W0].
Procesamiento:
Se calculan tres bits de paridad (P0,P1,P2) utilizando compuertas XOR. Se calcula un bit de paridad global G0
Se forma una palabra de 8 bits en formato: [G0, W3, W2, W1, P2, W0, P1, P0] correspondiente al Hamming (7,4) codificado.  
Salida: una palabra de 4 bits que corresponde al síndrome de la palabra codificada. En formato: [G0, S2, S1, S0]

2) Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [G0, W3, W2, W1, P2, W0, P1, P0] del interruptor de 8 switch.
Procesamiento:
Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [G0] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global.
Salida: Síndrome de la palabra transmitida [G1, C2, C1, C0] (utilizamos este formato para mayor comprensión del código).

3) Comparador:
Entrada: Síndrome de la palabra codificada y transmitida.
Procesamiento: 
Con compuertas XOR se comparan ambos síndromes de modo que se obtienen una coordenada en binario de la posición del error en la palabra recibida.
Casos:
Síndrome = 000 → no hay error detectado en los 7 bits principales, excluye bit global.
Si el síndrome ≠ 000 → indica la posición del bit con error.
Se revisa el bit de paridad global G0:
Si síndrome ≠ 000 y G0 falla → se corrige un error de 1 bit en la posición indicada.
Si síndrome = 000 y G0 falla → se detecta un error de 2 bits (DED) que no puede corregirse.
Salida: la posición de error que corresponde los bits comparados [eG, e2, e1, e0].

4) Corrector
Entrada: posición de error y la palabra recibida
Procesamiento:
Utilizando un mux corrige los bits presentes en la palabra recibida por el switch de 8 puertos, ignorando el bit global, utilizando la posición del error anterior.
Salida: devuelve una palabra de 5 bits que corresponde a los bits de datos que contiene la palabra recibida ya corregida.
Si el error es corregible : [0, W3, W2, W1, W0] 
Si contiene 2 errores: [1, 0, 0, 0, 0]

5) Leds de la FPGA
Recibe la palabra corregida y pinta los leds de la FPGA invirtiendo los bits.

6) Conversor de Binario a Hexadecimal
Entradas: Palabra corregida 
Procedimiento:
Realmente este modulo pasa de binario a otro número en binario que según ese orden pinta los leds del siete segmentos en hexadecimal. 
Salida: leds que pinta el siete segmentos.

7) multiplexor
Entrada: recibe por entrada un reloj, un reset, la palabra corregida y la posición, ánodo y siete segmentos.
Procedimiento:
Utilizando una frecuencia de refresco de 27 kHz se realiza un divisor de frecuencia y un reset síncrono.
```
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
```
Seguidamente se llama al modulo de binario a hexadecimal dos veces con la intensión de guardar en una variable la posición del error y en otra el numero corregido en hexadecimal. Se puede hacer esto ya que la posición del error es un numero que va del 0 al 6 por lo que no afecta en nada utilizar la misma función. Otro aspecto para tomar en cuenta es que en caso de no presentar ningún error el siete segmentos muestra un guion (-) y si hay dos errores ambos siete segmentos muestra el guion.
Para finalizar el multiplexor, se decide que señal sale de acuerdo al divisor de frecuencia. De modo que se intercalan los siete segmentos activos.
```
    // 3) Multiplex activo-bajo
    // sel=0 -> anodo=2'b10 (enciende dígito 0), seven_w
    // sel=1 -> anodo=2'b01 (enciende dígito 1), seven_e
    assign anodo = sel ? 2'b01 : 2'b10;
    assign seven = sel ? seven_e : seven_w;
```
Salida: valores para el ánodo y el siete segmentos.



### 3.2 Diagramas de bloques de cada subsistema

Subsistema 1; prepara una referencia de cómo debería lucir la palabra codificada si no hubiera errores.

<img width="601" height="246" alt="Captura de Pantalla 2025-09-22 a la(s) 2 12 58 p  m" src="https://github.com/user-attachments/assets/d2cf3b4b-cb47-4eaf-a82f-c9a061f7d1d2" />

Subsistema 2; analiza la palabra recibida y obtiene un síndrome que refleja posibles errores.

<img width="605" height="185" alt="Captura de Pantalla 2025-09-22 a la(s) 2 13 34 p  m" src="https://github.com/user-attachments/assets/f69e0a13-dfc6-4bca-b15d-bcff8807ef1a" />

Subsistema 3; localiza en qué bit está el error (si lo hay).

<img width="607" height="230" alt="Captura de Pantalla 2025-09-22 a la(s) 2 14 13 p  m" src="https://github.com/user-attachments/assets/0a2939ef-41b9-43de-ba43-20b8953b866b" />

Subsistema 4; reconstruye los datos originales corrigiendo un error simple o detectando un error doble.

<img width="614" height="254" alt="Captura de Pantalla 2025-09-22 a la(s) 2 14 47 p  m" src="https://github.com/user-attachments/assets/d9d8915e-8534-4cc9-aa55-838576b52ecb" />

Subsistema 5; despliega la palabra corregida y apaga LEDs si hubo error doble.

<img width="603" height="165" alt="Captura de Pantalla 2025-09-22 a la(s) 2 16 01 p  m" src="https://github.com/user-attachments/assets/cd8ba9af-ba17-468a-bd42-6ee7f60c4c34" />

Interconexion; 

conmutador_4 → modulo_01 → sindrome_ref.

conmutador_8 → modulo_02 → sindrome_detec.

sindrome_ref y sindrome_detec → modulo_03 → pos_error.

conmutador_8 y pos_error → modulo_04 → w_corregida_b4.

w_corregida_b4 → modulo_05 → leds.

clk, rst, w_corregida_b4, error_pos → modulo_07 → anodo, seven

El modulo 06 es llamado dentro del modulo 07 para pasar de binario a hexadecimal.

Así se cierra toda la ruta de datos: desde la entrada de switches hasta la corrección y visualización

## 4. Simplificacion de ecuaciones booleanas 

### 4.1 Ejemplo de la simplificación de las ecuaciones booleanas usadas para el circuito corrector de error.

En el modulo_04 se corrigen los bits usando la información del síndrome.
Por ejemplo, pensemos en la paridad P0.
En la versión original se definía como:

P0 = w0 ⊕ 𝑤1 ⊕ 𝑤 3

Al expresarlo en álgebra booleana tradicional:

P0=( w0 * (w1 * w3)' )+( w0 * ( w1 * w3)' )+( w0 * (w1 * w3)' )+( w0 * (w1 * w3)' )

Al aplicar mapa de Karnaugh de 3 variables (w0, w1, w3), se ve que la expresión se reduce al XOR de las tres entradas:

P0 = w0 ⊕ w1 ⊕ w3

Esto muestra cómo se pasa de una expresión con 4 minterms a una sola operación XOR.

### 4.2 Ejemplo de la simplificación de las ecuaciones booleanas usadas para los leds o de los 7-segmentos

En caso de tener 4 bits de salida corregidos D3D2D1D0 y se pretende encender un LED indicador cuando el número binario es mayor que 9 (para representar A–F en hexadecimal). La tabla de verdad asociada corresponde a;

<img width="325" height="142" alt="Captura de Pantalla 2025-09-18 a la(s) 8 38 52 a  m" src="https://github.com/user-attachments/assets/e6310ca8-e873-4d35-93d2-88cd1f28fd79" />

Ecuación booleana inicial (suma de minterms):
LED= (D3 * D2' * D1 * D0') + (D3 * D2' * D1 * D0) + (D3 * D2 * D1' * D0') + (D3 * D2 * D1' * D0) + (D3 * D2 * D1 * D0') + (D3 * D2 * D1 * D0)

Se puede simplicar a;

LED = D3 * (D2 + D1)


## 8. Testbench ( Ejemplo y análisis de una simulación funcional del sistema completo, desde el estímulo de entrada hasta el manejo de los 7 segmentos)

El printf del testbench imprimió Tiempo, conmutador_4, conmutador_8 y led.
Se observa que el testbench cambió valores cada 10 000 ps (10 ns).
Al final, $finish se llamó en el tiempo 70 ns → por eso la simulación termina ahí.
Esto confirma que la simulación está corriendo y guardando el .vcd.

<img width="522" height="128" alt="Captura de Pantalla 2025-09-23 a la(s) 11 22 01 a  m" src="https://github.com/user-attachments/assets/95965d10-0527-4861-beb0-77f2690f8332" />

Al ejecutar el make wv;
Se abre el archivo tb_modulo_top.vcd en GTKWave.
A la izquierda (SST) se tiene la jerarquia de señales (tb_modulo_top).
En el centro, la lista de señales que se seleccionan.
A la derecha, las formas de onda.

<img width="1220" height="777" alt="Captura de Pantalla 2025-09-23 a la(s) 10 55 51 a  m" src="https://github.com/user-attachments/assets/a183c5f3-80b9-49ca-8ab9-2f05360a24ed" />


## 9. Oscilador de anillo
Al realizar la medecion en el osciloscopio se determino una frecuencia de 9.7 MHz

<img width="800" height="480" alt="DS04-3_inversores" src="https://github.com/user-attachments/assets/10fdd3ba-cf76-411b-bccb-b358e4304bd6" />

Con esto se puede calcular el tiempo de propagación promedio del inversor TTL;

T = 1/f = 1/9.7 MHz

T = 103.09 nS

T = 2*N*tpd

103.09 nS = 2 * 5 * tpd

tpd = 103.09 ns/ 10

tpd = 10.39 nS


Para un oscilador de 3 inversores, el periodo de oscilacion deberia ser;

T = 2 * 3 * 10.39 nS

T = 62.34 nS

Cada inversor tiene un tiempo de retatardo asociado, al disminuir la cantidad de inversores disminuye tambien el periodo de oscilacion, al usar una una pieza larga de alambre los factores fisicos no ideales de la misma se hacen mas presente, aumentando asi el periodo de oscilacion. 


## 10. Consumo de recursos 

```
Printing statistics.

=== modulo_top ===

   Number of wires:                266
   Number of wire bits:            508
   Number of public wires:         266
   Number of public wire bits:     508
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                322
     ALU                            24
     DFFR                           15
     DFFRE                           1
     GND                             1
     IBUF                           14
     LUT1                           42
     LUT2                           13
     LUT3                           25
     LUT4                           75
     MUX2_LUT5                      62
     MUX2_LUT6                      24
     MUX2_LUT7                       9
     MUX2_LUT8                       2
     OBUF                           14
     VCC                             1

```

## 11. Problemas encontrados durante el proyecto

- Problema en el subsistema 7 para encender los dos siete segmentos al mismo tiempo. El problema se corrigió al definir un número de pin para el reset en la fpga.
- Problema para corregir la palabra recibida. El problema estaba causado por una mala definición de los pines, se usó por error {} cuando de manera correcta es con [].


## Apendices:
### Apendice 1:
texto, imágen, etc
