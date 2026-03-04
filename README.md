# Capítulo 2 – Flex & Bison

## Ejercicio 1 – Versión 2

### Análisis
El patrón ^.*\n no funciona porque en Flex el operador punto (.)
no incluye el salto de línea. Debido a esto, el escáner termina
procesando carácter por carácter.

### Solución encontrada
Se propone utilizar el patrón:

[^\n]*\n

ya que captura todos los caracteres hasta encontrar un salto de línea.
### Conclusión
El uso del patrón ^.*\n no es adecuado en Flex porque el punto
no incluye el carácter de nueva línea. Es necesario incluir
explícitamente \n en la expresión regular para capturar líneas
completas.
