# Seccion 1: Introducción al curso

instalaciones recomendadas: https://gist.github.com/Klerith/591fff6e2a393f19beb698ed44f0aa5e

-   hoja de atajos: https://devtalles.com/files/sql/postgres-cheatsheet.pdf

# Seccion 2: Preparar ambiente de pruebas

lo recomendable es hacerlo con docker y table plus

# Seccion 3: Generalidades y primeros pasos

## Intro a las DB

Tipos de DB:

-   SQL: relacionales -> luce como una hoja de excel
-   NoSQL: no relacionales -> luce como un json

## Shortcuts

Las comillas dobles (") solo hacen referencia a una tabla. El resto de las ocaciones (para seleccionar valores, etc) se usa comillas simples (') .
Recuerda que SQL es Case Sensitive  
**El uso del punto y coma (;) en SQL es recomendado, _pero también opcional_.**

**Códigos de TablePlus**

-   F5 = Recarga TablePlus
-   Ctrl + S = Se realiza un "commit". (... además guarda el archivo).
    -   Al cerrar TablePlus, se guardan automaticamente los cambios recientes.
-   Ctrl + E (Ctrl + T) = Nueva pestaña (SQL Query) para insertar codigo SQL
-   Ctrl + W = Cierra una pestaña abierta en TablePlus. O la ventana de TablePlus

**Códigos en la pestaña SQL Query de TablePlus**

-   Ctrl + I = Formatea el código SQL.
-   Ctrl + } = Comenta la línea SQL
-   Ctrl + Enter = Ejecuta **solo un fragmento de código** SQL (no todos). _O el código que hayas seleccionado con el cursor_.
    -   Con fragmento de código me refiero a aquel pedazo de código que está rodeado o separado por punto y coma (;)... si no lo separas por (;) entonces SQL lo tomará todo tu código no separado como un fragmento entero.
-   Ctrl + Shift + Enter = Ejecuta **todo el código** SQL.

## Práctica

**Código de práctica**

Trabajando con 01-usuarios.sql

```SQL

-- *** crear tabla
create table users (name VARCHAR(10) UNIQUE);


-- *** insertar registros
INSERT INTO
    users (name)
VALUES('Andre');


-- *** actualizar registros
UPDATE
    users
SET
    name = 'Kath'
WHERE
    name = 'Andre';


-- *** seleccionar registros
SELECT * FROM users LIMIT 3 OFFSET 3;


-- *** cláusula where
SELECT * FROM users WHERE name='Andrea';
SELECT * FROM users WHERE name LIKE '%ndr%';
SELECT * FROM users WHERE name LIKE 'Andrea_';
SELECT * FROM users WHERE name LIKE '_ndrea';


-- *** eliminar registros: similar al SELECT
DELETE FROM
    users
WHERE
    name LIKE '_ndrea';

-- *** DROP vs TRUNCATE table
-- elimina completamente la tabla
DROP table users;
-- borra todos los registros de la tabla (limpia la tabla)
TRUNCATE table users;


-- *** operadores de strings y funciones
SELECT
    id,
    name,
    UPPER(name),
    LENGTH(name) AS longitud_name,
    (20 * 5) AS cte,
    CONCAT(id, ' - ', UPPER(name), ' -> ', LENGTH(name)) AS codigo
FROM
    USERS;
-- en vez del concatenar con las comas (,) también puedes usar el doble tubo (||)


-- *** Intermedio - Substring y Position
SELECT
    id,
    name,
    SUBSTRING(name, 0, 7),
    POSITION(' ' IN name),
    SUBSTRING(name, 0, POSITION(' ' IN name)) AS PrimerNombre,
    SUBSTRING(name, POSITION(' ' IN name) + 1) AS SegundoNombre
FROM
    users;


-- *** Tarea - First y Last Name - Columnas
SELECT * FROM users;
UPDATE
    users
SET
    first_name = SUBSTRING(name, 0, POSITION(' ' IN name)),
    last_name = SUBSTRING(name, POSITION(' ' IN name) + 1);

```
