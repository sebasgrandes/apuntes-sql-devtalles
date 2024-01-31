

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;

-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT nextval('language_code_seq' :: regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);


-- Empezar con el select para confirmar lo que vamos a actualizar

-- paso previo: creando los registros en language
SELECT DISTINCT language FROM countrylanguage ORDER BY language ASC;

INSERT INTO language (name)
SELECT DISTINCT language FROM countrylanguage ORDER BY language ASC;

-- si no sabes cual va a dentro o a fuera... entonces solo fijate en: 1. a que tabla le quieres agregar el code?... esa es la que va a fuera 2. el "code", esta es la clave... aquella tabla que tenga el "code" entonces será aquella que va adentro
SELECT a.language, (SELECT (name, code) FROM language b WHERE b."name" = a."language") FROM countrylanguage a; -- asegurandonos de que esta correcto
SELECT a.language, (SELECT (name, code) FROM language b WHERE b."name" = a."language") FROM countrylanguage a; -- lo mismo de arriba pero una forma mas curiosa
SELECT a.language, (SELECT code FROM language b WHERE b."name" = a."language") FROM countrylanguage a; -- asegurandonos para pasar al siguiente paso
-- Actualizar todos los registros

UPDATE countrylanguage a SET languagecode=(SELECT code FROM language b WHERE b."name" = a."language");

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
ALTER TABLE countrylanguage
ALTER COLUMN languagecode TYPE int4
USING languagecode::integer;
-- podrias intentar hacerlo manual en la columna (en la estructura de la tabla) pero solo estarías haciendo las 2 primeras lineas anteriores... por lo que no funcionaria.


-- Crear el forening key y constraints de no nulo el language_code

-- fk creado manualmente
-- si te sale error al crear el fk, creas un unique index
CREATE UNIQUE INDEX "unique_country_language" ON countrylanguage (languagecode);

-- constraint
ALTER TABLE countrylanguage
ALTER COLUMN languagecode SET NOT NULL; -- se añade la restriccion de not null. antes de aplicarlo deberias asegurarte de que no hay valores nulos en dicha columna, si los hay, debes actualizarlos o eliminar las filas. también debes asegurarte de que estos cambios no violen las restricciones de integridad referencial (como el hecho de que todos los valores de la tabla languagecode deben existir en la tabla language)
-- para mas info sobre este constraint y su diferencia con "check"... checa la carpeta dudas el archivo constraintnotnull.md

-- Revisar lo creado
SELECT * FROM countrylanguage;


