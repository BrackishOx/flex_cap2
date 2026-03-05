## Capitulo 2 Ejercicio Flex
 Flex + GCC

## Ejercicio 1
Enunciado

Example 2-3 procesa caracteres uno a uno.
¿Por qué no usar un patrón como .*\n para procesar líneas completas?
Proponer un patrón que sí funcione.

Problema

En Flex:

El punto . NO incluye el salto de línea (\n).

Flex utiliza la estrategia maximal munch (coincidencia más larga posible).

El patrón .*\n puede generar comportamientos inesperados o ineficientes.

.* puede interferir con otras reglas al intentar consumir demasiado texto.

Solución Implementada

Se utilizó el patrón:

[^\n]*\n

Este patrón significa:

Cualquier carácter excepto salto de línea.

Repetido cero o más veces.

Terminado en \n.

Esto permite procesar correctamente el texto línea por línea de forma controlada y eficiente.

## Ejercicio 2
Enunciado

Modificar el programa de concordancia para que no distinga entre mayúsculas y minúsculas, sin hacer copias adicionales de las palabras.

Problema

El programa original trataba:

"Hola"

"hola"

"HOLA"

como palabras diferentes.

Solución Implementada

Se realizaron dos modificaciones principales:

 Modificación en symhash()

Se usa tolower() al calcular el hash:

hash = hash * MULT + tolower(c);

Esto garantiza que el cálculo del hash sea independiente de mayúsculas o minúsculas.

Modificación en lookup()

Se reemplazó strcmp() por strcasecmp():

if (!strcasecmp(sp->name, sym))

Esto permite comparar palabras ignorando diferencias entre mayúsculas y minúsculas.

Resultado

El programa ahora cuenta correctamente palabras como:

Hola hola HOLA

como una sola entrada:

Hola: 3
## Ejercicio 3
Enunciado

La tabla hash del programa tiene tamaño fijo.
Modificarla para que no falle cuando se llene.
Implementar una solución usando técnicas estándar como:

Chaining

Rehashing

Problema

El código original usaba:

#define NHASH 9997
struct sym *symtab[NHASH];

Esto crea una tabla de tamaño fijo que no puede crecer dinámicamente.
Si el número de símbolos aumenta considerablemente, el rendimiento disminuye debido a más colisiones.

Solución Implementada

Se convirtió la tabla en una estructura dinámica:

struct sym **symtab;
int table_size;
int num_symbols;
 Características Implementadas

Tamaño inicial configurable (INITIAL_SIZE).

Control del load factor.

Rehash automático cuando:

(num_symbols / table_size) > 0.75

Duplicación del tamaño de la tabla.

Reinserción de todos los elementos (rehashing).

Funcionamiento del Rehash

Cuando la tabla supera el 75% de ocupación:

Se duplica el tamaño de la tabla.

Se crea una nueva estructura dinámica.

Se recalculan los hashes usando el nuevo tamaño.

Se reinsertan todos los símbolos existentes.

Se libera la tabla anterior.

Compilación

Para cualquier ejercicio:

flex archivo.l
gcc lex.yy.c -o programa -lfl

Ejemplo:

flex flex_cap2_ej3.l
gcc lex.yy.c -o ej3 -lfl
