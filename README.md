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
El sistema se organiza en tres grandes bloques:

1) Codificador (Transmisor)
Entrada: una palabra binaria de 4 bits, seleccionada mediante interruptores.
Procesamiento:
Se calculan tres bits de paridad (P1,P2,P3) utilizando compuertas XOR. Se calcula un bit de paridad global P0
Salida: se forma una palabra de 8 bits en formato: [[P0,P1,P2,D1,P3,D2,D3,D4]]
Esta palabra se envía al “canal” y puede ser visualizada en LEDs o enviada hacia un banco de interruptores que permiten inyectar errores (cambiar manualmente uno o más bits).

3) Canal con errores introducidos
La palabra de 8 bits se pasa a través de un conjunto de switches o jumpers, donde el usuario puede simular la presencia de ruido en el canal.
Si no se altera ningún bit → la palabra llega intacta.
Si se altera 1 bit → el sistema podrá detectarlo y corregirlo.
Si se alteran 2 bits → el sistema detectará el error doble, pero no lo corregirá.

3) Decodificador (Receptor)
Entrada: palabra de 8 bits recibida.
Procesamiento: Se recalculan las paridades y se obtiene el síndrome de 3 bits.
Si el síndrome = 000 → no hay error detectado en los 7 bits principales.
Si el síndrome ≠ 000 → indica la posición del bit con error.
Se revisa el bit de paridad global P0:
Si síndrome ≠ 000 y P0 falla → se corrige un error de 1 bit en la posición indicada.
Si síndrome = 000 y P0 falla → se detecta un error de 2 bits (DED) que no puede corregirse.
Si síndrome ≠ 000 y P0 correcto → el error está en P0.
Finalmente, se extraen los 4 bits de datos corregidos (D1..D4).

4) Visualización
Los 4 bits de datos corregidos se muestran en un conjunto de LEDs, permitiendo observar el valor binario restaurado.
Un LED adicional indica si ocurrió un error doble detectado (DED). De forma opcional, el circuito puede mostrar tanto la palabra recibida como la palabra corregida, mediante un selector (switch).

### 3.2 Diagramas de bloques de cada subsistema



### 3.1 Módulos
### -- Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```

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



## 5. Parametros

- Lista de parámetros

## 6. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

## 7. Criterios de diseño
Diagramas, texto explicativo...

## 8. Testbench
Descripción y resultados de las pruebas hechas

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

Cada inversor tiene un tiempo de retatrdo asociado, al disminuir la cantidad de inversores disminuye tambien el periodo de oscilacion, al usar una una pieza larga de alambre los factores fisicos no ideales de la misma se hacen mas presente, aumentando asi el periodo de oscilacion. 


## 10. Consumo de recursos

## 11. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
