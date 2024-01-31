# Seccion 7: Joins - Uniones

## Códigos de Práctica

### JOINS

```SQL

-- en vez de borrar las tablas una a una averiguando cual es su dependencia o fk... puedes solo borrar la carpeta raiz de posgresssql, y volverla a montar en docker... así tendrás todo limpio

-- *** Cláusula - UNION
-- esto solo es una suma o adicion de selects para que aparezcan en filas (A + B)
SELECT code, name, 'primer' FROM continent WHERE name LIKE '%America%'
UNION
SELECT code, 'segundo', name FROM continent WHERE code IN (1,2,3,5,7);

SELECT code, name FROM continent WHERE name LIKE '%America%'
UNION
SELECT code, name FROM continent WHERE code IN (1,2,3,5,7);

-- *** Unión de tablas - Where
-- el where también puede servir para unir... PERO...
-- no se recomienda usar el where... mejor usa los joins

SELECT a.name as country, b.name as continent FROM country a, continent b
WHERE a.continent = b.code
ORDER by country ASC;

-- *** INNER JOIN
 -- recuerda que inner join es la interseccion (A && B)
SELECT a.name, b.name FROM country a INNER JOIN continent b ON a.continent = b.code;

SELECT * FROM country;

-- *** Alterar secuencias - Insertar nuevo continente

-- las secuencias, una vez se crean, continuan con su secuencia... para alterar esto o "corregirlo" digamos:
ALTER SEQUENCE 'continent_code_seq' RESTART WITH 8;
-- el nombre de al secuencia la sacas de la estructura de tu tabla

-- *** FULL OUTER JOIN
-- esta es la union completa (A || B)
SELECT
    a.name as pais,
    a.continent as continente_del_pais,
    b.code as codigo_continente,
    b.name as continente
FROM
    country a FULL
    OUTER JOIN continent b ON a.continent = b.code
ORDER BY
    a.continent DESC;

-- *** RIGHT OUTER JOIN
-- esta es la union menos A (A || B ~ A)
SELECT
    a.name as countryname,
    a.continent as countrycontinent,
    b.code as continentcode,
    b.name as continentname
FROM
    country a
    RIGHT OUTER JOIN continent b ON b.code = a.continent
WHERE
    a.continent IS NULL;

-- *** Aggregations + Joins

SELECT count(*), b.name FROM country a INNER JOIN continent b ON a.continent = b.code GROUP BY b.name ORDER BY count(*) DESC; -- recuerda que inner join es la interseccion

SELECT count(*), b.name FROM country a FULL OUTER JOIN continent b ON a.continent = b.code GROUP BY b.name ORDER BY count(*) DESC; -- con el full outer join, aquellos valores nulos los cuenta como 1... para solucionar o hacerlo de otra forma esto, el siguiente codigo ayuda:

(SELECT count(*) as conteo, b.name FROM country a INNER JOIN continent b ON a.continent = b.code GROUP BY b.name)
UNION
(SELECT 0 as conteo, b.name FROM country a RIGHT JOIN continent b ON a.continent = b.code WHERE a.continent IS NULL
ORDER BY conteo DESC);

```

### Múltiples Joins

```SQL

-- *** Multiples Joins con agrupaciones

-- recuerda siempre comenzar con la solución de poco en poco, no ataques defrente el problema grande...!!!

-- ¿Quiero saber los idiomas oficiales que se hablan por continente?

SELECT DISTINCT a.continent, b.language as lenguaje, c.name as continent_name, b.isofficial FROM country a
INNER JOIN countrylanguage b ON a.code = b.countrycode
INNER JOIN continent c ON a.continent = c.code
WHERE b.isofficial = true
ORDER BY continent_name ASC;

-- ¿Cuántos idiomas oficiales que se hablan por continente?

SELECT COUNT(*) AS total, continent_name FROM (
	SELECT DISTINCT a.continent, b.language as lenguaje, c.name as continent_name, b.isofficial FROM country a
	INNER JOIN countrylanguage b ON a.code = b.countrycode
	INNER JOIN continent c ON a.continent = c.code
	WHERE b.isofficial = true
	ORDER BY continent_name ASC
) AS idiomas
GROUP BY continent_name
ORDER BY total DESC;

-- *** Cuarta relación en el query
-- cuando llegas al punto de trabajar con una 4ta tabla... en vez de consonantes como alias... usa alias más específicos
SELECT DISTINCT b.languagecode as lenguaje_codigo, c.name as continent_name, d."name" AS idioma FROM country a
INNER JOIN countrylanguage b ON a.code = b.countrycode
INNER JOIN continent c ON a.continent = c.code
INNER JOIN language d ON b.languagecode = d.code
WHERE b.isofficial = true
ORDER BY continent_name ASC;

```
