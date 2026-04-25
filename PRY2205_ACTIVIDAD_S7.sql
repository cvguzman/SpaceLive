-- CASO 1 BONIFICACIÓN DE TRABAJADORES

-- MEJORA DE ACCESO Y SEGURIDAD DE TABLAS CREANDO SINÓNIMOS
CREATE SYNONYM SYN_TRABAJADOR FOR TRABAJADOR;
CREATE SYNONYM SYN_BONO_ANTIGUEDAD FOR BONO_ANTIGUEDAD;
CREATE SYNONYM SYN_TICKETS FOR TICKETS_CONCIERTO;

-- INSERCIÓN DE TABLA DETALLE_BONIFICACIONES_TRABAJADOR
INSERT INTO detalle_bonificaciones_trabajador (
    num,
    rut,
    nombre_trabajador,
    sueldo_base,
    num_ticket,
    direccion,
    sistema_salud,
    monto,
    bonif_x_ticket,
    simulacion_x_ticket,
    simulacion_antiguedad
) 
SELECT
    SEQ_DET_BONIF.NEXTVAL AS NUM, -- CREACIÓN SECUENCIA COLUMNA NUM
    t.numrut || '-' || t.dvrut AS "RUT",
    INITCAP(t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno) AS NOMBRE_TRABAJADOR,
    TO_CHAR(t.sueldo_base, '$999G999G999') AS SUELDO_BASE,
    NVL(TO_CHAR(tk.nro_ticket), 'No hay info') AS NUM_TICKET,
    INITCAP(t.direccion) AS "DIRECCION",
    UPPER(i.nombre_isapre) AS SISTEMA_SALUD,
    TO_CHAR(NVL(tk.monto_ticket, 0), '$999G999G999') AS MONTO,
    TO_CHAR(
        CASE -- BONO TICKET
           WHEN tk.monto_ticket IS NULL THEN 0
           WHEN tk.monto_ticket <= 50000 THEN 0
           WHEN tk.monto_ticket <= 100000 THEN tk.monto_ticket * 0.05
           ELSE tk.monto_ticket * 0.07
      END, '$999G999G999') AS BONIF_X_TICKET,
    TO_CHAR(
    t.sueldo_base +
        CASE -- SUELDO CON TICKET
           WHEN tk.monto_ticket IS NULL THEN 0
           WHEN tk.monto_ticket <= 50000 THEN 0
           WHEN tk.monto_ticket <= 100000 THEN tk.monto_ticket * 0.05
           ELSE tk.monto_ticket * 0.07
      END, '$999G999G999') AS SIMULACION_X_TICKET,
    TO_CHAR(t.sueldo_base * (1 + b.porcentaje), '$999G999G999') AS SIMULACION_ANTIGUEDAD -- BONO ANTIGUEDAD NON EQUI JOIN
FROM syn_trabajador t
LEFT JOIN syn_tickets tk
    ON t.numrut = tk.numrut_t
INNER JOIN isapre i
    ON t.cod_isapre = i.cod_isapre
INNER JOIN syn_bono_antiguedad b
    ON FLOOR(MONTHS_BETWEEN(SYSDATE, t.fecing)/12)
        BETWEEN b.limite_inferior AND b.limite_superior
WHERE t.cod_isapre> 0.04 
    AND FLOOR(MONTHS_BETWEEN(SYSDATE, t.fecnac)/12) < 50;

-- SE EJECUTA COMMIT PARA CERRAR LA TRANSACCION Y PODER VISUALIZAR EL ORDEN MONTO DESC Y NOMBRE_TRABAJADOR ASC
COMMIT;

-- VISUALIZACIÓN INFORMACIÓN POR COLUMNA MONTO DESC Y NOMBRE_TRABAJADOR ASC
SELECT *
FROM detalle_bonificaciones_trabajador
ORDER BY monto DESC, nombre_trabajador;

-- CASO 2 VISTAS

-- ETAPA 1 Vista V_AUMENTOS_ESTUDIOS
-- CREACIÓN DE SINÓNIMOS PRIVADOS PARA MEJORAR SEGURIDAD Y ABSTRACCIÓN DE TABLAS 
CREATE SYNONYM S_TRABAJADOR FOR TRABAJADOR;
CREATE SYNONYM S_ESCOLARIDAD FOR PRY2205_S7.BONO_ESCOLAR;

-- CREACIÓN VISTA V_AUMENTOS_ESTUDIOS
CREATE OR REPLACE VIEW V_AUMENTOS_ESTUDIOS AS
SELECT
    TO_CHAR(t.numrut, '99G999G999') AS RUT_TRABAJADOR,
    INITCAP(t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno) AS TRABAJADOR,
    UPPER(e.descrip) AS DESCRIPC,
    TO_CHAR(e.porc_bono, 'FM0000000') AS PCT_ESTUDIOS,
    t.sueldo_base AS SUELDO_ACTUAL,
    ROUND(t.sueldo_base * (e.porc_bono / 100)) AS AUMENTO, -- AUMENTO CALCULADO
    TO_CHAR(
        ROUND(t.sueldo_base + (t.sueldo_base * (e.porc_bono / 100))),
        '$999G999G999') AS SUELDO_AUMENTADO -- CÁLCULO SUELDO AUMENTADO
FROM S_TRABAJADOR t
INNER JOIN S_ESCOLARIDAD e
    ON t.id_escolaridad_t = e.id_escolar
WHERE 
    (
        t.id_categoria_t = 3 -- FILTRO TRABAJADORES TIPO CAJERO
        OR
        (
            SELECT COUNT(*) -- FILTRO CON 1 O 2 CARGAS FAMILIARES 
            FROM PRY2205_S7.ASIGNACION_FAMILIAR af
            WHERE af.numrut_t = t.numrut
        ) IN (1,2)
    );
    
-- DATOS RECUPERADOS DE V_AUMENTOS_ESTUDIOS ORDENADOS POR PCT_ESTUDIOS Y TRABAJADOS ASC
SELECT *
FROM v_aumentos_estudios
ORDER BY 4,1;
    
    
-- ETAPA 2 OPTIMIZACIÓN DE CONSULTAS 
-- SE CREA ÍNDICE FUCTION BASE DE COLUMNA APMATERNO
CREATE INDEX idx_trabajador_apm_2 ON trabajador (UPPER(apmaterno));
-- SE CREA ÍNDICE ADICIONAL 
CREATE INDEX idx_trabajador_isapre ON trabajador (cod.isapre);
-- PLAN EJECUCIÓN OPTIMIZADO
SELECT 
    numrut, 
    fecnac, 
    t.nombre, 
    appaterno, 
    t.apmaterno
FROM trabajador t
INNER JOIN isapre i
    ON i.cod_isapre = t.cod_isapre
WHERE UPPER(t.apmaterno) = 'CASTILLO'
ORDER BY t.nombre;

-- VALIDACIÓN DEL PLAN DE EJECUCIÓN 
EXPLAIN PLAN FOR
SELECT 
    t.numrut, 
    t.fecnac, 
    t.nombre, 
    t.appaterno, 
    t.apmaterno
FROM trabajador t
WHERE UPPER(t.apmaterno) = 'CASTILLO'
ORDER BY t.nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

