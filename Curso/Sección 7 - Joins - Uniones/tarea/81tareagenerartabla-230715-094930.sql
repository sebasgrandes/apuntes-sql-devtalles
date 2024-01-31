
-- *** TAREA 1
-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

-- resolucion con LIKE
-- gracias al WHERE cortas o limitas un pedacito de la union
-- RECUERDA QUE EL count VIENE DE LA CANTIDAD DE DATOS DE LA INTERSECCION...
(SELECT count(*) as Total, b.name as Continente FROM country a
INNER JOIN continent b ON a.continent = b.code
WHERE b.name NOT LIKE '%America%'
GROUP BY b.name)

UNION

(SELECT count(*) as Total, 'America' as Continente FROM country a
INNER JOIN continent b ON a.continent = b.code
WHERE b.name LIKE '%America%')
ORDER BY Total DESC;

-- lo mismo con es con IN, solo reemplaza LIKE por IN y ya

-- *** TAREA 2
-- Quiero que me muestren el país con más ciudades
-- Campos: total de ciudades y el nombre del país
-- usar INNER JOIN

-- este es mi inner join (interseccion de ciudad con pais)
SELECT b.name, a.name as pais FROM country a
INNER JOIN city b ON a.code=b.countrycode;
-- SELECT * as pais FROM country a

-- ahora se agrupa por pais y además se cuenta...
-- RECUERDA QUE EL count VIENE DE LA CANTIDAD DE DATOS DE LA INTERSECCION...
SELECT count(*) as total_ciudades, a.name as pais FROM country a
INNER JOIN city b ON a.code=b.countrycode
GROUP BY pais
ORDER BY total_ciudades DESC;

-- como nos piden solo la que tiene mas ciudades... usamos LIMIT
SELECT count(*) as total_ciudades, a.name as pais FROM country a
INNER JOIN city b ON a.code=b.countrycode
GROUP BY pais
ORDER BY total_ciudades DESC
LIMIT 1;


-- FORMA ALTERNA (ES LO MISMO SOLO CAMBIANDO ORDEN de uso de las tablas en el query): CAMBIANDO LA POSICIÓN DE LAS TABLAS -> FROM ... INNER JOIN ...
select count(*) as total, b. name as country from City a
INNER join country b on a. countrycode = b. code
GROUP by b. name
order by count(*) desc
limit 1;
