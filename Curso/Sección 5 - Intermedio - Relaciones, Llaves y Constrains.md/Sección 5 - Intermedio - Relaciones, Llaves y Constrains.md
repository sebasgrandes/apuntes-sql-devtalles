# Sección 5: Intermedio - Relaciones, Llaves y Constrains

## Introducción a las relaciones

Tipos de Relaciones

-   Uno a Uno- One to One
-   Uno a muchos - One to many
-   Relaciones a si mismas - Self Joining relationships
-   Muchos a Muchos - Many to Many

## Introducción a las llaves

Una llave es un constrain (restricción). Su objetivo es identificar registros de manera unica... también establecer relaciones.

Tipos de Keys (Llaves)

-   **Primary Key**: Identifica un registro de forma única.
-   **Super Key**: Conjunto de atributos que identifican de forma unica a un registro. Es un superconjunto de una clave candidata.
-   Canditate Key: Conjunto de atributos que identifican de forma unica a un registro. Menos la llave primaria, las demás se consideran claves candidatas.
-   Foreign Key: Se usan para apuntar a la llave primaria de otra tabla.
-   Composite Key: Cuando una llave primaria consta de más de un atributo.

Es mejor no depender de llaves de terceros.

## Alter table - Drop Constraint

https://www.postgresql.org/docs/7.2/sql-altertable.html

## Índices de base de datos

Si buscas un dato en una db, recorrerá tooodos los registros (hasta que lo encuentre, y una vez así, tratará de encontrar duplicados)... esto a veces es lento  
Aquí entran a tallar los índices, que definimos para ayudar

## Códigos de Práctica

### Keys

```SQL

-- *** añadiendo una llave primaria - manualmente
-- añadiendo la llave primaria: NO SE PUEDE PORQUE HAY 1 REGISTRO DUPLICADO EN LA COLUMNA code
ALTER TABLE
    country
ADD
    PRIMARY KEY (code);

-- ANTES DE BORRAR RECUERDA PRIMERO TRATAR DE HACER EL QUERY DE SELECT
    -- viendo el registro duplicado
SELECT
    *
FROM
    country
WHERE
    code = 'NLD';

-- asegurandonos de seleccionar solo el registro duplicado
SELECT
    *
FROM
    country
WHERE
    code = 'NLD'
    AND code2 = 'NA';

-- borrando el registro duplicado
SELECT
DELETE FROM
    country
WHERE
    code = 'NLD'
    AND code2 = 'NA';

-- añadiendo la llave primaria
ALTER TABLE
    country
ADD
    PRIMARY KEY (code);


-- *** Constraint - Check
    -- el check es un constraint especial para verificar ciertas condiciones en los campos
ALTER TABLE
    country
ADD
    CHECK (surfacearea >= 0);
-- una vez realizado el check, verás que en la estructura de la tabla, aparece algo más detallado en dicha columna (en mi caso no sucede)


-- *** Check con múltiples posibilidades strings
-- añadiendo un check... también puedes usar IN
SELECT
    DISTINCT continent
FROM
    country;
ALTER TABLE
    country
ADD
    CHECK (
        (continent = 'Asia' :: TEXT)
        OR (continent = 'South America' :: TEXT)
        OR (continent = 'North America' :: TEXT)
        OR (continent = 'Oceania' :: TEXT)
        OR (continent = 'Antarctica' :: TEXT)
        OR (continent = 'Africa' :: TEXT)
        OR (continent = 'Europe' :: TEXT)
        OR (continent = 'Central America' :: TEXT)
    );

-- editando mi check... (no es tan sencillo como volver a ejecutar mi sql query)
    -- para editar el check: 1. borras el check (con su nombre) 2. lo añades o aplicas de nuevo
ALTER TABLE
    country DROP CONSTRAINT "country_continent_check2";
-- en los editores visuales generalmente puedes copiar las estructuras, por ejemplo de creación de check o tablas.
    -- en table plus: click derecho a la tabla del sidebar izquierdo (Tables) > Copy as Script > ...

```

### Índices

Para más info sobre los indices ve a ./dudas/indices.md

```SQL
-- *** Creando índices

SELECT * FROM country WHERE continent='Africa';

-- los indices mejoran la velocidad (de búsqueda), pero también aumenta el peso de la db
-- los indices unicos son mas rapidos

-- aparece en tu structure
CREATE UNIQUE INDEX "unique_country_name" ON country (name);

CREATE UNIQUE INDEX "country_continent" ON country (continent);

-- *** Unique Index - Problemas de la vida real

-- se recomienda colocar indices  en las columnas mas buscadas... porque esto también demora en su creacion. es decir, mientras se crea el indice no puedes hacer otras ediciones

-- recuerda que no puedes crear indices cuyos valores de columnas, tengan registros repetidos

CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city(name, countrycode, district);

SELECT
    *
FROM
    city
WHERE
    name = 'Jinzhou'
    AND countrycode = 'CHN'
    AND district = 'Liaoning';

CREATE INDEX "indice_distrito" ON city(district);
```

### Llave foranea

```SQL
-- *** Creando llaves foráneas (en city)

-- creando una llave foranea... de uno a muchos?

ALTER TABLE city
	ADD CONSTRAINT fk_country_code
	FOREIGN KEY (countrycode) -- campos que establecen la llave
	REFERENCES country(code);

-- añadiendo el pais faltante en la tabla country
INSERT INTO
    country
values(
        'AFG',
        'Afghanistan',
        'Asia',
        'Southern Asia',
        652860,
        1919,
        40000000,
        62,
        69000000,
        NULL,
        'Afghanistan',
        'Totalitarian',
        NULL,
        NULL,
        'AF'
    );

-- *** Llave foránea con countrylanguage

ALTER TABLE countrylanguage
	ADD CONSTRAINT "fk_country_code"
	FOREIGN KEY (countrycode)
	REFERENCES country (code);

-- una vez hecha esta relacion, no puedes borrar el code de country... a menos que definas un estilo en delete de tu fk


-- *** ON DELETE - CASCADE

-- si el codigo de una columna cambia mucho... puede que no sea un buen candidato para un fk

SELECT * FROM country WHERE code='AFG';
SELECT * FROM city WHERE countrycode='AFG';
SELECT * FROM countrylanguage WHERE countrycode='AFG';

-- edita manualente tu fk de city y countrylanguage, para que en "on delete" selecciones "cascade"...  asi al borrar una referencia en country... borrarás en cascada todos los registros de las relaciones

DELETE FROM country WHERE code='AFG';
```
