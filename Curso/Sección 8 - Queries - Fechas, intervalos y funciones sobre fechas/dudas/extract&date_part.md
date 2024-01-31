# explicame este codigo sql: MAKE_INTERVAL(YEARS:= date_part('years', CURRENT_DATE)::INTEGER - EXTRACT(YEARS FROM hire_date)::integer) as computed

El código SQL que has proporcionado está utilizando una función llamada `MAKE_INTERVAL` junto con algunas funciones de extracción de componentes de fecha para calcular un intervalo de tiempo. Vamos a desglosarlo:

1. **MAKE_INTERVAL**: Esta función se utiliza para crear un intervalo de tiempo basado en una cantidad específica de años, meses, días, etc. En este caso, solo se está especificando la parte de los años (`YEARS:= ...`).

2. **date_part('years', CURRENT_DATE)::INTEGER**:

    - `CURRENT_DATE`: Es una función que devuelve la fecha actual.
    - `date_part('years', ...)`: Esta función extrae la parte del año de una fecha dada. En este caso, está extrayendo el año de la fecha actual.
    - `::INTEGER`: Este es un operador de casteo en SQL, que se está utilizando para asegurarse de que el resultado sea un número entero.

3. **EXTRACT(YEARS FROM hire_date)::integer**:
    - `hire_date`: Asumimos que es una columna en la tabla a la que se está haciendo referencia, que contiene la fecha de contratación de una persona o de un evento.
    - `EXTRACT(YEARS FROM ...)`: Similar a `date_part`, esta función extrae la parte del año de la fecha dada. En este caso, está extrayendo el año de la columna `hire_date`.
    - `::integer`: De nuevo, esto asegura que el resultado es un número entero.

La línea completa de código está calculando el intervalo de tiempo, en años, entre la fecha actual y la fecha de contratación (`hire_date`). La función `MAKE_INTERVAL` está creando un intervalo con esa cantidad de años.

El alias `as computed` al final simplemente le da un nombre a la columna resultante de este cálculo, que en este caso será `computed`.

En resumen, este fragmento de código SQL está diseñado para calcular cuántos años completos han pasado desde la fecha `hire_date` hasta la fecha actual, y presentar ese número de años como un intervalo de tiempo bajo la columna `computed`.
