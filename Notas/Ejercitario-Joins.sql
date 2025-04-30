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

--SELECT SUBSTR(FILE_NAME,INSTR(FILE_NAME,'\',-1)+1
--FROM DBA_DATA_FILES;

--NOTAS

--VERIFICAR DIA QUE COMIENZA LA SEMANA
SELECT NEXT_DAY(TRUNC(SYSDATE), 1) AS dia1 FROM dual;


/*
10 - Se pretende realizar el aumento salarial del 5% para todas las categorías. Debe listar la 
categoría (código y nombre), el importe actual,  el  importe aumentado al 5% (redondeando la 
cifra a la centena), y la diferencia.  
Formatee la salida (usando TO_CHAR)  para que los montos tengan los puntos de mil. 
*/

--OB

SELECT CS.COD_CATEGORIA, CS.NOMBRE_CAT, TO_CHAR(CS.ASIGNACION,'999G999G999'),
TO_CHAR(ROUND((CS.ASIGNACION *1.05),-2),'999G999G999') AS "AUMENTADO AL 5%", 
TO_CHAR((ROUND((CS.ASIGNACION *1.05),-2) - CS.ASIGNACION),'999G999G999') AS "DIFERENCIA"
FROM B_CATEGORIAS_SALARIALES CS;

/*
 Considerando la fecha de hoy,  indique cuándo caerá el próximo DOMINGO.
*/

SELECT NEXT_DAY(TRUNC(SYSDATE), 7) FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'DOMINGO') AS PROXIMO_DOMINGO FROM DUAL;

/*
Utilice la función LAST_DAY para determinar si este año es bisiesto o no. Con CASE  y con 
DECODE, haga aparecer la expresión ‘bisiesto’ o ‘no bisiesto’ según corresponda. (En un 
año bisiesto el mes de febrero tiene 29 días)  
*/

SELECT LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),1)) AS "ULTIMO DIA",
DECODE(LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),1)), TO_DATE('28/02/25')  , 'NO BISIESTO' ,'BISIESTO'),
CASE
	WHEN 
		LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),1)) = TO_DATE('28/02/25') 
	THEN
		'NO BISIESTO'
	ELSE
		'BISIESTO'
END TIPO
FROM DUAL;

/*
13- Tomando en cuenta la fecha de hoy, verifique que fecha dará redondeando al año? Y 
truncando al año? Escriba el resultado.  Pruebe lo mismo suponiendo que sea el 1 de Julio del 
año. Pruebe también el 12 de marzo.
*/

SELECT ROUND(SYSDATE,'YEAR') FROM DUAL;

SELECT TRUNC(SYSDATE,'YEAR') FROM DUAL;

SELECT ROUND(TO_DATE('01/07/25'),'YEAR') FROM DUAL;

SELECT TRUNC(TO_DATE('01/07/25'),'YEAR') FROM DUAL;

SELECT ROUND(TO_DATE('12/03/25'),'YEAR') FROM DUAL;

SELECT TRUNC(TO_DATE('12/03/25'),'YEAR') FROM DUAL;

/*
14- Imprima su edad en años y meses. Ejemplo: Si nació el 23/abril/1972, tendría 43 años y 3 
meses a la fecha. 
*/

SELECT ('tendría '|| TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE('16/10/1995'))/12) ||'  años y '|| 
ROUND(MONTHS_BETWEEN(SYSDATE, TRUNC(SYSDATE,'YEAR'))) || ' meses a la fecha') AS "EDAD" FROM DUAL;

/*
15. Determine la fecha y hora del sistema en el formato apropiado. 
*/

SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY HH:MM') FROM DUAL;

/*
16. Liste  ID y NOMBRE de todos los artículos que no están incluidos en ninguna VENTA. Debe 
utilizar necesariamente la sentencia MINUS.
*/

SELECT ID, NOMBRE FROM B_ARTICULOS
MINUS
SELECT DV.ID_ARTICULO , A.NOMBRE
FROM B_DETALLE_VENTAS DV
JOIN B_ARTICULOS A
ON A.ID = DV.ID_ARTICULO;


/*
 El área de CREDITOS Y COBRANZAS solicita un informe de las ventas a crédito 
efectuadas en el año 2018 y cuyas cuotas tienen atraso en el pago. A las cuotas que se 
encuentran en dicha situación se le aplica una tasa de interés del 0.5% por cada día de atraso. 
Se considera que una cuota está en mora cuando ya pasó la fecha de vencimiento y no existe 
aún pago alguno. Se pide mostrar los siguientes datos y ordenar de forma descendente por 
días de atraso. 
Nº FACTURA 
VENDEDOR 
RUC_CI 
CLIENTE 
CUOTA 
FECHA VTO 
MONTO CUOTA 
INTERÉS 
DÍAS DE ATRASO 
MONTO A PAGAR 
*/

SELECT V.NUMERO_FACTURA, E.NOMBRE||' '||E.APELLIDO AS "VENDEDOR", DECODE(P.TIPO_PERSONA, 'F', P.CEDULA, 'J', P.RUC)AS RUC_CI,
P.NOMBRE||' '||P.APELLIDO AS "CLIENTE", PG.NUMERO_CUOTA||'/'||V.PLAZO AS "CUOTA", 
TO_CHAR(PG.MONTO_CUOTA,'999G999G999') AS MONTO_CUOTA, 
ROUND(SYSDATE - PG.VENCIMIENTO )AS "DIAS DE ATRASO",
TO_CHAR((0.005 * ROUND(SYSDATE - PG.VENCIMIENTO) * PG.MONTO_CUOTA),'999G999G999') AS "INTERES",
TO_CHAR(((0.005 * ROUND(SYSDATE - PG.VENCIMIENTO) * PG.MONTO_CUOTA) + PG.MONTO_CUOTA),'999G999G999')AS "MONTO CUOTA"
FROM B_PLAN_PAGO PG
JOIN B_VENTAS V
ON V.ID = PG.ID_VENTA
JOIN B_EMPLEADOS E 
ON E.CEDULA = V.CEDULA_VENDEDOR
JOIN B_PERSONAS P
ON P.ID = V.ID_CLIENTE
WHERE P.ES_CLIENTE ='S' AND V.TIPO_VENTA = 'CR'
AND EXTRACT(YEAR FROM V.FECHA) = '2018'
AND (PG.SALDO_CUOTA = PG.MONTO_CUOTA AND PG.VENCIMIENTO < SYSDATE );

/*
18. El Dpto. Financiero de la empresa necesita un informe de los movimientos correspondientes a 
compras y ventas efectuadas en el primer semestre del año 2018. 
El informe debe contener: 
 Fecha de la operación. 
 Concepto: Para obtener esta columna debe concatenar las expresiones y/o campos: 
 Operación: Venta o Compra de mercaderías según factura.
 Tipo de Factura: Contado o Crédito. 
 Factura: para obtener el formato Nº 000-000-0000000, debe concatenar el número '001' + 
el id de la localidad del proveedor o cliente + el número de factura.  
Recuerde rellenar con ceros hasta alcanzar la cantidad de caracteres establecidos para 
cada grupo. Ejemplos: 
'VENTA DE MERCADERÍAS SEGÚN FACTURA CONTADO Nº 001-002-0003264' 
'COMPRA DE MERCADERÍAS SEGÚN FACTURA CREDITO Nº 001-002-0003264'  
 Monto Débito: Si es una compra se coloca el monto de la operación, pero si es una venta 
se coloca 0. 
 Monto Crédito: Si es una venta se coloca el monto de la operación, pero si es una compra 
se coloca 0. 
Por último, se pide que ordene los registros por la fecha en forma ascendente.
(NO HAY TABLA DE COMPRAS)
*/

SELECT V.FECHA, 'VENTA '|| V.TIPO_VENTA ||' '||'001-'|| LPAD(P.ID_LOCALIDAD,3,0) ||'-'|| LPAD(V.NUMERO_FACTURA,7,0) AS CONCEPTO,
V.MONTO_TOTAL AS MONTO_CREDITO
FROM B_VENTAS V
JOIN B_PERSONAS P
ON P.ID = V.ID_CLIENTE
WHERE V.FECHA BETWEEN TO_DATE('01/01/2018','DD/MM/YYYY') AND TO_DATE('30/06/2018','DD/MM/YYYY')
ORDER BY V.FECHA ASC;