# Sección 6: Intermedio - Separación de data en otras tablas

## Códigos de Práctica

### Tabla de continentes

```SQL

-- si tienes relaciones entre tablas, dadas por un fk... debes borrar primero aquellas tablas donde estan los fk... por ejemplo primero borra countrylanguage y city... y al final country
DROP TABLE countrylanguage;
DROP TABLE city;
DROP TABLE country;

-- *** Tabla de continentes
-- no agregamos code pq esto al ser un serial, es autoincrementado
INSERT INTO
    continent (name)
SELECT
    DISTINCT continent
FROM
    country
ORDER BY
    continent ASC;

SELECT * FROM continent;
```

### Relación, checks y respaldo de country

```SQL
-- *** Relación, checks y respaldo de country

-- antes de impactar una tabla de db, siempre ten un respaldo, de seguridad o haz tu codigo en una copia... habla con el administrador. De esta forma tendras una forma de revertirlo.
-- en tu caso, ahora por ejemplo, puedes copíar el script de creacion de la tabla continente... (copy script as -> creation)... y ejecutarlo como un query cambiando el nombre de tabla a country_bk -> este es tu respaldo.

-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."country_bk" (
    "code" bpchar(3) NOT NULL,
    "name" text NOT NULL,
    "continent" text NOT NULL,
    "region" text NOT NULL,
    "surfacearea" float4 NOT NULL,
    "indepyear" int2,
    "population" int4 NOT NULL,
    "lifeexpectancy" float4,
    "gnp" numeric(10,2),
    "gnpold" numeric(10,2),
    "localname" text NOT NULL,
    "governmentform" text NOT NULL,
    "headofstate" text,
    "capital" int4,
    "code2" bpchar(2) NOT NULL,
    PRIMARY KEY ("code")
);
-- insertando valores a la tabla backup
-- !! no es necesario definir los campos en tu nueva tabla... basta con el select
INSERT INTO
    country_bk
SELECT
    *
FROM
    country;

SELECT * FROM country_bk;

-- ahora quiero borrar el constraint check de mi tabla country... para lo cual, como no se como se llama dicho constraint, entonces edito por ejemplo un dato de la columna continent para que me muestre el error y saber el nombre
SELECT
    *
FROM
    country;

-- borrando mi constraint check
ALTER TABLE country DROP CONSTRAINT country_continent_check;
```

### Actualización masiva

```SQL
-- *** Actualización masiva
-- primero nos aseguramos de estar seleccionando lo correcto... usamos alias a las tablas (si se puede)
-- antes de colocar "code" o si estas inseguro de que corresponde correctamenta -> para asegurarte que estas obteniendo los mismos resultados... cambia "code" por "name" -> asi te dará los mismos nombres, de uno (tabla country) y otro lado (tabla continent)
SELECT a.name, a.continent, (SELECT name FROM continent b WHERE b.name = a.continent) FROM country a;
SELECT a.name, a.continent, (SELECT (name, code) FROM continent b WHERE b.name = a.continent) FROM country a; -- lo mismo de arriba pero una forma mas curiosa
-- una vez asegurado, ahora si procedemos a asegurarnos de nuevo con el code para pasar al proximo paso
SELECT a.name, a.continent, (SELECT code FROM continent b WHERE b.name = a.continent) FROM country a;


-- actualizando de forma masiva
UPDATE country a SET continent=(SELECT code FROM continent b WHERE b.name = a.continent);
```

### Cambio de tipo y llave foránea

```SQL
-- *** Cambio de tipo y llave foránea

-- Cambio de tipo
-- quiero cambiar, de mi tabla country, el tipo de dato de la columna continent (que antes era string, y ahora es solo un numero)
ALTER TABLE country
ALTER COLUMN continent TYPE int4
USING continent::INTEGER;
-- en caso de que no funcione, hay varias salidas

-- Llave foranea... puedes hacerlo manual
-- si te lanza un error por el index, crea uno:
CREATE UNIQUE INDEX idx_unique_code ON continent ("code");

-- en codigo, la llave creada es esta:
ALTER TABLE country
ADD FOREIGN KEY (continent) REFERENCES continent (code);

```
