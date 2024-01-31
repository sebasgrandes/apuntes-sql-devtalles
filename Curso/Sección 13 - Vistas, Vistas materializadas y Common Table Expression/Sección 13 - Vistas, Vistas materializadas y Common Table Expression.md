# Sección 13: Vistas, Vistas materializadas y Common Table Expression

## Introducción a la sección

Una vista es como una seleccion de un query. una vista materializada es casi lo mismo pero que la data se coloca en una nueva tabla.

Common Table Expression: es como un subquery.

## Vistas

https://www.postgresql.org/docs/current/sql-createview.html

## Cambiar nombre de vistas y vistas materializadas

https://www.postgresql.org/docs/8.3/sql-alterview.html

## Common Table Expressions - CTE

https://www.postgresql.org/docs/current/queries-with.html  
https://gist.github.com/Klerith/080066dcfb992a80f69f136650d249fd

## CTE Recursivo

https://www.postgresql.org/docs/15/queries-with.html

# Ejemplo sin recursividad - Preparación

Ejemplo con CTE recursivo: https://thanh-nguyen.medium.com/building-a-recommendation-system-using-postgresql-advanced-feature-recursive-cte-6e3e7a381d52

## Códigos de Práctica

### Vistas y Vistas materializadas

```SQL

-- *** Vistas

-- puedo usar una vista, para tener que reusar el query de abajo, y que me sirve para traer la info
-- crear una vista es como poner un alias a un query que es tedioso estar escribiendolo una y otra vez

-- creando la vista: la vista no se almacena en memoria.
-- si quieres insertar una columna (editar) de la vista, puedes añadirlo normalmente y usar el "or replace"
-- si quieres borrar o eliminar cierto codigo (o hasta reordenar de posicion las columnas)... tendras que hacer drop a la vista y luego crearla nuevamente
CREATE OR REPLACE VIEW comments_per_week AS
	SELECT date_trunc('week', posts.created_at) as weeks,
		count(DISTINCT posts.post_id) as number_of_posts,
		count(*) as number_of_claps,
		sum(claps.counter) as total_claps
	FROM posts
	INNER JOIN claps ON claps.post_id = posts.post_id
	GROUP BY weeks
	ORDER BY weeks DESC;


SELECT * FROM claps WHERE post_id=1;

-- usando la vista: cuando llamas la vista, estas mandando a llamar el mismo query
SELECT * FROM comments_per_week;
SELECT weeks, total_claps FROM comments_per_week;
SELECT sum(total_claps) FROM comments_per_week; -- esto es ineficiente porque toma el query y le agrega dicho sum

-- borrando la vista
DROP VIEW comments_per_week;


-- *** Vistas materializadas
-- una vista materializada es una copia de una vista, pero en memoria... es como que creara una tabla.
-- la vista tradicional es solo una llamada a un query.
-- la vista materializda... una vez se crea esta vista, se crea esa información ahí mismo en dicha vista, de forma tangible... ocupa espacio en tu db. cuando consultemos la vista, no se ejecuta ningun query. el beneficio es por ejemplo que cuando un cliente por ejemplo quiera ver rapidamente los datos, consultemos esta vista, sin tener que afectar o meter mano en la db original. el problema también esta en que nosotros (manualmente) tenemos que actualizar la data. LA VISTA MATERIALIZADA ES MAS RAPIDA Y EFICIENTE

CREATE MATERIALIZED VIEW comments_per_week_mat AS
	SELECT date_trunc('week', posts.created_at) as weeks,
		count(DISTINCT posts.post_id) as number_of_posts,
		count(*) as number_of_claps,
		sum(claps.counter) as total_claps
	FROM posts
	INNER JOIN claps ON claps.post_id = posts.post_id
	GROUP BY weeks
	ORDER BY weeks DESC;

SELECT * FROM comments_per_week; -- se ejecuta el query en la tabla original, por lo que siempre esta actualizada

SELECT * FROM comments_per_week_mat; -- toma la referencia materializada, por lo que si cambiamos algo en la tabla original, no se reflejará el cambio hasta que lo actualicemos manualmente

REFRESH MATERIALIZED VIEW comments_per_week_mat; -- refrezcando o actualizando la vista materializada

SELECT * FROM posts WHERE post_id = 1;

-- *** Cambiar nombre de vistas y vistas materializadas

-- 1. crear de nuevo la vista pero con otro nombre: no siempre es factible. por ejemplo con las vistas materializadas pueden tomar tiempo o esfuerzo en crear

-- 2. cambiando el nombre con query

ALTER VIEW comments_per_week RENAME TO posts_per_week;
ALTER MATERIALIZED VIEW comments_per_week_mat RENAME TO posts_per_week_mat;

```

### Common Table Expressions - CTE

```SQL

-- *** Common Table Expressions - CTE
-- un CTE es una consulta o tabla virtual con un resultado. pero es util para hacerlo de forma simplificada

-- casos en donde se utilizan los CTES: 1. simplificar nuestros querys

WITH posts_week_2024 AS (
	SELECT date_trunc('week'::text, posts.created_at) AS weeks,
		sum(claps.counter) AS total_claps,
		count(DISTINCT posts.post_id) AS number_of_posts,
		count(*) AS number_of_claps
	FROM posts
	JOIN claps ON claps.post_id = posts.post_id
	GROUP BY (date_trunc('week'::text, posts.created_at))
	ORDER BY (date_trunc('week'::text, posts.created_at)) DESC
)
SELECT * FROM posts_week_2024
WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31' AND total_claps > 600;

-- *** Multiples CTEs

WITH claps_per_post AS (
	SELECT post_id, sum(counter) FROM claps
	GROUP BY post_id
), posts_from_2023 AS (
	SELECT * FROM posts WHERE created_at BETWEEN '2023-01-01' AND '2023-12-31'
)
SELECT * FROM claps_per_post WHERE claps_per_post.post_id IN (SELECT post_id FROM posts_from_2023);

-- *** CTE Recursivo

-- cuando tengamos una estructura de niveles o jerarquica, es util el cte recursivo

-- nombre de la tabla en memoria
WITH RECURSIVE countdown(val) AS (
	-- inicialización -> el primer nivel o valores iniciales
	SELECT 5 AS val
	UNION
	-- Query recursivo
		SELECT val - 1 FROM countdown
		-- Condicion para salirnos del query recursivo
		WHERE val > 1
)
-- Select de los campos
SELECT * FROM countdown;

-- *** CTE Recursivo - Números ascendentes

WITH RECURSIVE numeros_ascendentes(val) AS (
	-- init
	SELECT 1 val
	UNION
		-- recursiva
		SELECT val + 1 FROM numeros_ascendentes WHERE val < 10
)
SELECT * FROM numeros_ascendentes;

-- *** CTE Recursivo - Tabla de multiplicar


WITH RECURSIVE multiplication_table(base, val, result) AS (
	-- init
-- 		SELECT 5 AS base, 1 AS val, 5 AS result -- si usas este select, puedes omitir esos parametros de arriba
		VALUES(5, 1, 5)
	UNION
		-- recursiva
		SELECT 5, val+1, (val+1)*base FROM multiplication_table
		WHERE val < 10
)
SELECT * FROM multiplication_table;

-- *** Preparación de la tabla - Employees

SELECT * FROM employees;

SELECT * FROM employees WHERE reports_to >= 1;

-- *** CTE Recursivo - Estructura organizacional

WITH RECURSIVE bosses AS (
		SELECT id, name, reports_to FROM employees WHERE id=1
	UNION
		-- de esta manera la recursion avanza a través de la jerarquía de informes, relacionando cada empleado con su supervisor
		SELECT employees.id, employees.name, employees.reports_to FROM employees
		INNER JOIN bosses ON bosses.id = employees.reports_to
)
SELECT * FROM bosses;

-- *** CTE Recursivo - Estructura organizacional con límite

WITH RECURSIVE bosses AS (
		SELECT id, name, reports_to, 1 AS depth FROM employees WHERE id=1
	UNION
		-- de esta manera la recursion avanza a través de la jerarquía de informes, relacionando cada empleado con su supervisor
		SELECT employees.id, employees.name, employees.reports_to, depth + 1 FROM employees
		INNER JOIN bosses ON bosses.id = employees.reports_to
		WHERE depth < 4 -- con esto intervienes en la recursividad, evitando que se procese mas y mas... lo cual es conveniente, en vez de colocarlo fuera del recursive
)
SELECT * FROM bosses;


-- *** Tarea - Mostrar nombres de los jefes

WITH RECURSIVE bosses AS (
		SELECT id, name, reports_to, 1 AS depth FROM employees WHERE id=1
	UNION
		-- de esta manera la recursion avanza a través de la jerarquía de informes, relacionando cada empleado con su supervisor
		SELECT employees.id, employees.name, employees.reports_to, depth + 1 FROM employees
		INNER JOIN bosses ON bosses.id = employees.reports_to
		WHERE depth < 4 -- con esto intervienes en la recursividad, evitando que se procese mas y mas... lo cual es conveniente, en vez de colocarlo fuera del recursive
)
SELECT bosses.*, employees.name FROM bosses
LEFT JOIN employees ON employees.id = bosses.reports_to
ORDER BY depth ASC;

```

### Ejemplos sin recursividad

```SQL

-- *** Ejemplo sin recursividad - Preparación

-- *** Resolución de la tarea

WITH seleccion_selectaxd AS (
	SELECT a.id, a.leader_id, b.name, a.follower_id FROM followers a
	INNER JOIN "user" b ON a.leader_id = b.id
)
SELECT d.*, c.name as follower_name FROM seleccion_selectaxd as d
INNER JOIN "user" c ON c.id = d.follower_id;

-- otra forma
select followers.*, leader.name as leader, follower.name as follower from followers
INNER join "user" leader on leader.id = followers.leader_id
INNER join "user" follower on follower.id = followers.follower_id;


-- *** Ejemplo sin recursividad

SELECT * FROM followers
WHERE leader_id IN (SELECT follower_id FROM followers WHERE leader_id = 1);

```
