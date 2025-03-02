--Comandos de Archivo SQL*Plus no finalizan con ;

--DECRIBE: muestra información sobre las columnas de la tabla denominada <nombre_tabla>, es decir, tipo de datos, longitud, si admite el nulo...
DESC B_EMPLEADOS

--LIST: Muestra el contenido del buffer

--RUN : Muestra y ejecuta el contenido del búfer.

--/ : Ejecuta el contenido del búfer sin mostrar la sentencia.

--SAVE archivo
 SAVE ARCHIVO.buf
 
--REPLACE archivo (sI YA EXITE)
 REPLACE ARCHIVO.buf
--GET archivo

--START archivo(Ejecuta el fichero)

--@ archivo(Ejecuta el fichero)

--EDIT archivo: Edicion en el buffer.
EDIT ARCHIVO.buf

--GET cargar en el buffer pero no lo ejecuta
GET ARCHIVO.buf

--SPOOL archivo: Crea un fichero con el nombre indicado en el que, a partir de ese momento, 
--se irá almacenando todo lo que vaya apareciendo por pantalla
--(eco): sentencias, resultados, mensajes de error...
--• Si no se indica extensión para el fichero, por defecto se toma ‘.lst’
--• El eco finaliza cuando se escribe SPOOL OFF 
SPOOL ARCHIVO2

SPOOL OFF

--EXIT: Salir

--Muestra las variables actuales del entorno
SHOW ALL

--Numero de lineas por pantalla, tamaño de pagina
SET PAGESIZE 100

--Maxima longitud de linea por pantalla
SET PAGESIZE 35

--SET PAU[SE] ON y SET PAU[SE] OFF : Para el scroll cuando alcanza el PAGESIZE activo, y espera un ENTER para continuar

--COLUMN <nombre_columna> FORMAT <formato>
--COLUMN <nombre_columna> FORMAT An
--• Visualiza una columna de tipo char o varchar2 con una anchura de n caracteres alfanuméricos 
--COLUMN <nombre_columna> FORMAT 999,999.999
--• Visualiza una columna de tipo number con el formato indicado, donde cada 9 significa ‘cualquier dígito del 0 al 9’.
--COLUMN <nombre_columna> DEFAULT
--• Establece el formato por defecto para la columna indicada
--COLUMN <nombre_columna> CLEAR
--• Elimina el formato para la columna indicada
--COLUMN <nombre_columna>
--• Muestra el formato actual establecido para la columna indicada 
-- COLUMN <NOMBRE COLUMNA> HEADING NOMBRE_NUEVO_COLUMNA
--COLUMN <NOMBRE_COLUMNA> JUSTIFY LEFT | RIGHT | CENTER

--append (a) : Añade texto al final de la línea de lo almacenado en el buffer

--change (c) : Cambia una expresión por otra (c/antigua/nuevo) 

--• del Para borrar líneas. Tiene varias opciones:
--• del Borra la línea actual
--• del n Borra la línea número n
--• del * Borra la línea actual
--• del n * Borra desde la línea n hasta la actual
--• del last Borra la última línea
--• del m n Borra las líneas situadas entre ellas.
--• del * n Borra la actual línea hasta la línea n.
--• input (i) Inserta el texto que quieras

--list (l) Muestra las líneas que hay en el buffer. Puede tener las siguientes combinaciones:
--• list n Muestra la línea n
--• list * Muestra la línea actual.
--• list n * Muestra las líneas entre la actual y el final
--• list last Muestra la última línea
--• list m n Muestra las líneas entre m y n

--Variables de sustitución. Se puede usar el símbolo (&) como variable de sustitución para:
--• Condiciones WHERE
--• Cláusulas ORDER BY
--• Expresiones de columnas
--• Nombres de tablas
--• Sentencias SELECT completas
--• Cuando se ejecuta, la sentencia solicita interactivamente el ingreso de los valores
-- Para strings y fechas, ponga la variable entre apóstrofes
--• Use (&&) si se desea reutilizar el valor de la variable sin tener que repetir el valor por cada ejecución

--DEFINE : Crea una variable de usuario de tipo CHAR.
DEFINE ced_empleado = 200

--ACCEPT : Acepta un valor introducido por el usuario y lo almacena en una variable, además de permitir 
--introducir literales informativos así como definir el tipo de variable.
ACCEPT dpto_id NUMBER PROMPT 'INGRESE EL ID DEL DEPARTAMENTO '
SELECT * FROM B_EMPLEADOS WHERE DPTO_ID = &dpto_id;

--UNDEFINE : elimina la definición de una variable
UNDEFINE ced_empleado