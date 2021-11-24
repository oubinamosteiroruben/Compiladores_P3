                         Readme      

Se trata de la implementación de una calculadora empleando
bison y flex. 

En dicha calculadora se pueden realizar distintas operaciones 
matemáticas, +,-,*,/,^, así como también otras como sin, cos, 
tan, exp, log, ln, ... 

Una característica de dicha calculadora es que únicamente 
mostrará el resultado de la operación cuando el usuario lo
indique, lo cual se podrá realizar insertando un ';' al 
finalizar cada expresión.

Para poder conocer todas las funciones que se pueden realizar
con la calculadora se deberá emplear el comando "HELP". Dicho
comando también mostrará otros comandos interesantes para el
usuario. 

Uno de los comandos que también mostrará la llamada "HELP", es 
ADD <archivo>. Esta función se empleará para añadir nuevas funciones
a la calculadora. Dichas funciones deberán ser implementadas
en un fichero .c y posteriormente se empleará la siguiente
instrucción en la terminal:

$> gcc funciones.c -o funciones.so -shared

** funciones.c es el nombre del archivo donde se implementan 
las funciones que se buscan. Cabe destacar que dichas funciones
deberán ser tener un único argumento (double) y devolverán un
valor (double).

Además de la creación de dicho archivo, se deberá crear otro con
el mismo nombre de tipo ".txt" en el que aparecerá una lista de
los nombres de las funciones que se desean guardar en la aplicación.

De esta forma, en este caso el comando que se empleará es 
"ADD funciones.so", ya que "funciones.so" es el fichero objeto 
en el que se guardará la librería. 

Otro comando que se implementa es LOAD <archivo> . Este comando
cambiará el sistema de entrada para un archivo indicado. Dicho 
archivo puede realizar llamadas recursivas a otros archivos, pero 
no podrá crearse un ciclo ya que tendría lugar un bucle infito.

El resto de comandos, tal como ya se comentó, se podrán conocer
con el comando "HELP".

-----------------------------------------------------------------------

Estructura:

La estructura de la calculadora consistirá en un analizador léxico 
que recibirá comandos por consola (o apartir de un archivo). En dichos
comandos se podrán encontrar identificadores, operandos, y numeros. 

Entre los identificadores se pueden encontrar funciones, variables y 
constantes, y solamente se guardarán en la tabla de símbolos en el 
momento en el que se inicialicen/definan.

El analizador léxico enviará un token determinado apartir del lexema
analizado. 

Por otro lado, el analizador sintáctico, apartir de una gramática, 
determinará si la instrucción introducida es correcta o no, y realizará
la acción correspondiente. 

-----------------------------------------------------------------------

Herramientas empleadas:

S.Operativo de prueba: Ubuntu 18.04
GCC: version 7.5.0
Flex: version 2.6.4
Bison (GNU bison): 3.0.4
GNU bash: 4.4.20
Valgrind: 3.13.0

-----------------------------------------------------------------------

Instrucciones:

Compilacion: $> sh compilar.sh
Ejecución: $> ./exe
Ejecución con valgrind: $> valgrind ./exe --leak-check=full -v
Conversor .c a código objeto .so: $> gcc funciones.c -o funciones.so -shared
