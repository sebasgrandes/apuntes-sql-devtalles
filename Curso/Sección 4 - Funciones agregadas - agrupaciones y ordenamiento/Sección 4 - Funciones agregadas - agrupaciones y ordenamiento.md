# Seccion 4: Funciones agregadas - agrupaciones y ordenamiento

## Exposición - Terminología y estructura

**Comandos de SQL, terminología**

-   DDL (Data Definition Language): Create, Alter, Drope Truncate
-   DML (Data manipulation Language): Insert, Delete, Update
-   TCL (Transaction Control Language): Commit, Rollback
-   DQL (Data Query Language): Select

**Funciones agregadas (aggregate functions)**

-   Count
-   Sum
-   Max
-   Min
-   Group By
-   Having
-   Order By

**Filtrando data**

-   Like
-   In
-   Is Null
-   Is Not Null
-   And
-   Or
-   Between

**Estructura general de un Select**

SELECT distinct o (\*) -> campos, alias, funciones
WHERE -> Condición, condiciones, and, or, in, like
JOINS
GROUP BY -> Campo agrupador, ALL
HAVING -> Condición
ORDER BY -> Expresión, Asc, DESC
LIMIT -> Valor, ALL
OFFSET -> Punto de inicio

## Práctica

**Código de práctica**

```SQL

-- *** Operador BETWEEN

SELECT
    first_name,
    last_name,
    followers
FROM
    users
WHERE
    followers BETWEEN 4000
    AND 4050
ORDER BY
    followers ASC;


-- *** Funciones agregadas - MAX MIN COUNT ROUND AVG
SELECT
    COUNT(*) AS total_users,
    MAX(followers) AS max_followers,
    MIN(followers) as min_followers,
    AVG(followers) AS avg_followers,
    ROUND(AVG(followers)) as round_avg_followers
FROM
    users;


-- *** GROUP BY
SELECT
    COUNT(*),
    followers
FROM
    users
WHERE
    followers BETWEEN 4000
    AND 5000
GROUP BY
    followers
ORDER BY
    followers DESC;


-- *** HAVING
-- el having funciona de la mano con el group by, para declarar condiciones
SELECT
    count(*),
    country
FROM
    users
GROUP BY
    country
HAVING
    count(*) < 3
ORDER BY
    count(*) DESC;


-- *** DISTINCT
-- el DISTINCT se usa para eliminar registros duplicados de un conjunto de resultados y devolver solo valores unicos
-- obteniendo todos los países (sin repeticion)
SELECT DISTINCT country FROM users;


-- *** Group By con otras funciones
SELECT
    SUBSTRING(email, POSITION('@' in email) + 1) AS dominio
FROM
    users;

SELECT
    count(*),
    SUBSTRING(email, POSITION('@' in email) + 1) AS dominio
FROM
    users
GROUP BY
    SUBSTRING(email, POSITION('@' in email) + 1)
HAVING
    count(*) > 1
ORDER BY
    count(*) DESC;
-- en algunas db por ejemplo oracle creo, se permite usar los alias ("dominio" por ejemplo) con el group by... en mi caso si me permitia, pero en otras db puede no funcionar.
-- para evitar repetir codigo es bueno crear funciones


-- *** SubQueries
-- los subqueries puede tener un impacto grande en el rendimiento de la db si es que se tienen demasiados registros
-- si no le pones un alias al count(*), en el query padre, este tendrá el nombre o podras seleccionarlo como "count"
-- recuerda que es ineficiente, general o idealmente no haces estos tipos de subquerys
SELECT
    total,
    -- SUM(total)
    dominio,
    edad
FROM
    (
        SELECT
            count(*) AS total,
            SUBSTRING(email, POSITION('@' in email) + 1) AS dominio,
            'sebastian' as nombre,
            27 as edad
        FROM
            users
        GROUP BY
            SUBSTRING(email, POSITION('@' in email) + 1)
        HAVING
            count(*) > 1
        ORDER BY
            count(*) DESC
    ) AS email_domains

```
