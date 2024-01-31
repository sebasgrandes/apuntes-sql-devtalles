# Sección 11: Ejercicios con base de datos de medium - Intro Funciones

## Preparación de la base de datos

Para importar los archivos (sql) que hemos descargado del material del profe... lo hacemos con pgadmin, luego volvemos a tableplus.

Todo está en la carpeta tarea.

## Códigos de Práctica: Funciones

```SQL

-- select original (a colocar dentro de la funcion)
select 
	json_agg( json_build_object(
	  'user', comments.user_id,
	  'comment', comments.content
	))
from comments where comment_parent_id = 1;


-- CREANDO LA FUNCION
CREATE OR REPLACE FUNCTION comment_replies(id INTEGER)
RETURNS json
AS -- cuerpo de la funcion
$$
-- el doble dolar, simboliza a las llaves cerradas (EL CUERPO DE LA FUNCION)
DECLARE result json;

BEGIN
	SELECT 
		json_agg( json_build_object(
		  'user', comments.user_id,
		  'comment', comments.content
		)) INTO result
	FROM comments WHERE comment_parent_id = id;
	
	RETURN result;
END;
$$
LANGUAGE plpgsql;

-- USANDO LA FUNCION
SELECT comment_replies(1);

-- usando la funcion dentro de un select

SELECT a.*,
	comment_replies(a.comment_id) as replies
FROM comments a
WHERE comment_parent_id IS NULL;

```