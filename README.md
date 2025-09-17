# Proyecto corto I: Diseño digital combinacional en dispositivos programables

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

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


### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
