# 📘 Proyecto: SpaceLive - Semana 

## 📝 Descripción general del proyecto

Se deberá obtener resultados específicos como solución a los requerimientos de cada desafío, aplicando el concepto de creación de objetos vistas con consultas SQL complejas, utilizando funciones simples, estadísticas o de grupo, joins
complejos entre varias tablas, filtros de datos, sinónimos e índices para optimizar las consultas.

### Objetivo general

Administrar bases de datos a partir del control de accesos a datos y objetos, y considerando la gestión de usuarios y privilegios del sistema, para la disponibilización de izar bases de datos según estándares de seguridad esperados.

### Alcance del modelo

- Conectarse como usuario `PRY2205_S7` y ejecutar el script de creación y poblamiento del esquema SpaceLive.
- Desarrollar consultas para:
  - **Caso 1 – Bonificación de trabajadores:** Determinar los montos simulados por concepto de tickets vendidos y compararlos con la bonificación por antigüedad, según los requisitos detallados por el área de Finanzas siguiendo las reglas del negocio.

     Script
    <img width="973" height="741" alt="Captura de pantalla 2026-04-23 a la(s) 23 07 26" src="https://github.com/user-attachments/assets/a9698c56-7a9f-44c0-8b0b-eceb244d9c5a" />

     Resultado en Consola
    <img width="1075" height="450" alt="Captura de pantalla 2026-04-25 a la(s) 12 31 11" src="https://github.com/user-attachments/assets/1e451aad-a115-4251-ae84-a36f37379ea4" />


  - **Caso 2 – Vistas:** Del cual consta de dos etapas:

  - Etapa 1 Vista V_AUMENTOS_ESTUDIOS: calcular una simulación de aumento salarial considerando el porcentaje que se encuentra en la tabla de parámetros BONO_ESCOLAR, además generar un objeto vista (View) de lectura denominado V_AUMENTOS_ESTUDIOS, que
contenga la siguiente información de cada trabajador: RUT, nombre y apellidos, nivel de educación, porcentaje de bono asociado a los estudios, sueldo actual, aumento calculado según el nivel de estudios y la simulación del sueldo con el aumento incorporado.      

  Script
  <img width="872" height="562" alt="Captura de pantalla 2026-04-25 a la(s) 13 57 33" src="https://github.com/user-attachments/assets/91cf017e-3540-4056-9e81-e1e7a0f6e5aa" />

  Resultado en Consola
  <img width="1009" height="664" alt="Captura de pantalla 2026-04-25 a la(s) 13 59 08" src="https://github.com/user-attachments/assets/1dc5238d-2ff5-4404-8dec-b7641d449af1" />

  - Etapa 2 Optimización de consultas: La empresa SpaceLive requiere ajustar las sentencias, ya que ha detectado una degradación en la BBDD. Necesita un plan de ejecución optimizado para una consulta SQL que filtra
registros por el apellido materno "CASTILLO" usando UPPER.

  Script
 <img width="807" height="585" alt="Captura de pantalla 2026-04-25 a la(s) 15 00 30" src="https://github.com/user-attachments/assets/972fffe1-dcc8-4f62-a19b-bff1cb309477" />

  Resultados en Consola
 <img width="912" height="606" alt="Captura de pantalla 2026-04-25 a la(s) 14 59 34" src="https://github.com/user-attachments/assets/39384c31-e477-42d0-9787-ccd61e8c74b2" />


---
## 👤 Autores del proyecto
- **Nombre completo:** Cinthya Guzman R. / Matias Suarez M.
- **Ramo:** Consulta de Bases de Datos
- **Grupo:** Grupo N°06
- **Sección:** 001A
- **Profesor:** Armando Romero M.
- **Carrera:** Analista Programador Computacional
- **Sede:** Carrera 100% Online
