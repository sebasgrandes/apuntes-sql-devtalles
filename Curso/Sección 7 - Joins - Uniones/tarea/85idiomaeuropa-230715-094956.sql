

-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";


SELECT count(*) as cantidad, a."language" as lenguaje_name, a.languagecode as lenguaje_codigo, b.continent FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
WHERE a.isofficial = true AND b.continent = 5
GROUP BY lenguaje_name, lenguaje_codigo, b.continent
ORDER BY cantidad DESC
LIMIT 1;


-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)

SELECT b."name" as pais, a."language" as lenguaje_name, a.languagecode as lenguaje_codigo, b.continent FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
WHERE a.isofficial = true AND b.continent = 5 AND a."language" = 'German';





