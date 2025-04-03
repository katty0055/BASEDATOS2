--EJERCITARIO JOINS


/*
Obtenga la lista de empleados con su posición y salario vigente (El salario y la categoría
vigente tienen la fecha fin nula – Un solo salario está vigente en un momento dado). Debe
listar:
Nombre área, Apellido y nombre del empleado, Fecha Ingreso, categoría, salario actual
La lista debe ir ordenada por nombre de área, y por apellido del funcionario.
*/

SELECT AR.NOMBRE_AREA, EM.APELLIDO||' '||EM.NOMBRE AS "APELLIDO Y NOMBRE DEL EMPLEADO",
EM.FECHA_ING, CS.NOMBRE_CAT AS "CATEGORIA", CS.ASIGNACION AS "SALARIO ACTUAL"
FROM B_EMPLEADOS EM
LEFT JOIN B_POSICION_ACTUAL POAC
ON POAC.CEDULA = EM.CEDULA
JOIN B_AREAS AR
ON AR.ID = POAC.ID_AREA
JOIN B_CATEGORIAS_SALARIALES CS
ON CS.COD_CATEGORIA = POAC.COD_CATEGORIA
WHERE CS.FECHA_FIN IS NULL 
AND POAC.FECHA_FIN IS NULL
ORDER BY AR.NOMBRE_AREA, 2
;

/*Algunos empleados de la empresa son también clientes. Obtenga dicha lista a través de una
operación de intersección. Liste cédula, nombre y apellido, teléfono. Tenga en cuenta sólo a
las personas físicas (F) que tengan cédula. Recuerde que los tipos de datos para operaciones
del álgebra relacional tienen que ser los mismos.
*/


SELECT TO_CHAR(E.CEDULA) AS CEDULA, E.NOMBRE, E.APELLIDO, E.TELEFONO 
FROM B_EMPLEADOS E
INTERSECT
SELECT TO_CHAR(P.CEDULA) AS CEDULA, P.NOMBRE, P.APELLIDO, P.TELEFONO 
FROM B_PERSONAS P
WHERE P.TIPO_PERSONA = 'F' AND P.CEDULA IS NOT NULL;


/*
Se necesita tener la lista completa de personas (independientemente de su tipo), ordenando
por nombre de localidad. Si la persona no tiene asignada una localidad, también debe
aparecer. Liste Nombre de Localidad, Nombre y apellido de la persona, dirección, teléfono
*/

SELECT L.NOMBRE, P.NOMBRE||' '||P.APELLIDO, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
LEFT JOIN B_LOCALIDAD L
ON P.ID_LOCALIDAD = L.ID
ORDER BY L.NOMBRE;

/*
En base a la consulta anterior, liste todas las localidades, independientemente que existan
personas en dicha localidad:
*/

SELECT L.NOMBRE, P.NOMBRE||' '||P.APELLIDO, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
RIGHT JOIN B_LOCALIDAD L
ON P.ID_LOCALIDAD = L.ID
ORDER BY L.NOMBRE;

/*
Obtenga la misma lista del ejercicio 3, pero asegurándose de listar todas las personas,
independientemente que estén asociadas a una localidad, y todas las localidades, aún cuando
no tengan personas asociadas.
*/

SELECT L.NOMBRE, P.NOMBRE||' '||P.APELLIDO, P.DIRECCION, P.TELEFONO
FROM B_PERSONAS P
FULL OUTER JOIN B_LOCALIDAD L
ON P.ID_LOCALIDAD = L.ID
ORDER BY L.NOMBRE;

/*
La organización ha decidido mantener un registro único de todas las personas, sean éstas
proveedores, clientes y/o empleados. Para el efecto se le pide una operación de UNION entre
las tablas de B_PERSONAS y B_EMPLEADOS. Debe listar
CEDULA, APELLIDO, NOMBRE, DIRECCION, TELEFONO, FECHA_NACIMIENTO.
En la tabla PERSONAS tenga únicamente en cuenta las personas de tipo FISICAS (F) y
que tengan cédula. Ordene la consulta por apellido y nombre
*/

SELECT TO_CHAR(E.CEDULA) AS CEDULA, E.NOMBRE, E.APELLIDO, E.TELEFONO, E.DIRECCION, 
E.FECHA_NACIM
FROM B_EMPLEADOS E
UNION
SELECT TO_CHAR(P.CEDULA) AS CEDULA, P.NOMBRE, P.APELLIDO, P.TELEFONO, P.DIRECCION, 
P.FECHA_NACIMIENTO
FROM B_PERSONAS P
WHERE P.TIPO_PERSONA = 'F' AND P.CEDULA IS NOT NULL
ORDER BY APELLIDO, NOMBRE;

/*
Liste el libro DIARIO correspondiente al año 2019, tomando en cuenta la cabecera y el
detalle. Debe listar los siguientes datos:
ID_Asiento, Fecha, Concepto, Nro.Linea, código cuenta, nombre cuenta, debe_haber,
Importe (para obtener el año puede usar LIKE).
*/

SELECT DC.ID, DC.FECHA, DC.CONCEPTO, DD.NRO_LINEA, DD.CODIGO_CTA, DD.DEBE_HABER,
DD.IMPORTE
FROM B_DIARIO_CABECERA DC
JOIN B_DIARIO_DETALLE DD
ON DC.ID = DD.ID
JOIN B_CUENTAS C
ON DD.CODIGO_CTA = C.CODIGO_CTA
WHERE DC.FECHA LIKE '%19';

/*
Transforme el ejercicio 7 para que obtenga los asientos de ENERO del 2019, condicionado al
campo DEBE_HABER , imprima el importe en la columna DEBITO o en la columna
CREDITO.
ID_Asiento, Fecha, Concepto, Nro.Linea, código cuenta, nombre cuenta, DEBITO,
CREDITO 
*/

SELECT DC.ID, DC.FECHA, DC.CONCEPTO, DD.NRO_LINEA, DD.CODIGO_CTA, DD.DEBE_HABER,
CASE DD.DEBE_HABER
	WHEN 'D' THEN DD.IMPORTE
	ELSE 0
END DEBITO,
CASE DD.DEBE_HABER
	WHEN 'C' THEN DD.IMPORTE
	ELSE DD.IMPORTE
END CREDITO
FROM B_DIARIO_CABECERA DC
JOIN B_DIARIO_DETALLE DD
ON DC.ID = DD.ID
JOIN B_CUENTAS C
ON DD.CODIGO_CTA = C.CODIGO_CTA
WHERE DC.FECHA LIKE '%01/19';

/*
. El campo FILE_NAME del archivo DBA_DATA_FILES contiene el nombre y camino de
los archivos físicos que conforman los espacios de tabla de la Base de Datos. Seleccione:
-Solamente el nombre del archivo (sin mencionar la carpeta o camino)
*/

SELECT SUBSTR(FILE_NAME,INSTR(FILE_NAME,'\',-1)+1)
FROM DBA_DATA_FILES;

--NOTAS

--VERIFICAR DIA QUE COMIENZA LA SEMANA
SELECT NEXT_DAY(TRUNC(SYSDATE), 1) AS dia1 FROM dual;


