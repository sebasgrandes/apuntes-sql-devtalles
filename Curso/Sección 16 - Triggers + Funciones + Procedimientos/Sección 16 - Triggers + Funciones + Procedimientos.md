# Sección 16: Triggers + Funciones + Procedimientos

## Encriptar y verificar contraseña

https://www.postgresql.org/docs/current/pgcrypto.html

## Triggers

https://www.postgresql.org/docs/current/sql-createtrigger.html

## Códigos de Práctica

### Funciones + Procedimientos

```SQL

-- *** Encriptar y verificar contraseña

CREATE EXTENSION pgcrypto;

INSERT INTO "user" (username, password)
VALUES ('sebastian', crypt('123456', gen_salt('bf')));


SELECT * FROM "user"
WHERE password = crypt('123456', password);


-- *** Procedimiento almacenado - user_login

CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS $$
DECLARE was_found BOOLEAN;

BEGIN
	SELECT count(*) INTO was_found FROM "user"
	WHERE username = user_name AND password = crypt(user_password, password);

	IF (was_found = false) THEN
		INSERT INTO session_failed (username, "when") VALUES (user_name, now());
		COMMIT;
		RAISE EXCEPTION 'Usuario y contraseña no son correctos'; -- cuando lanzamos una exception, se hace automaticamente un rollback de las modificaciones que intentamos hacer... A MENOS DE QUE ESTABLEZCAS EXPLICITAMENTE UN COMMIT (ASI COMO ARRIBA)
	END IF;

	-- actualizando al tabla de usuarios
	UPDATE "user" SET last_login = now() WHERE username = user_name;
	RAISE NOTICE 'Usuaario encontrado %', was_found;
	COMMIT; -- si todo sucede de manera correcta (con el update por ejemplo) el commit se sobreentiende

	-- recuerda que puedes o no colocar return pq es un procedimiento almacenado
END;
$$ LANGUAGE plpgsql;

CALL user_login('sebastian', '123456');

```

### Triggers

```SQL


CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS $$
DECLARE was_found BOOLEAN;

BEGIN
	SELECT count(*) INTO was_found FROM "user"
	WHERE username = user_name AND password = crypt(user_password, password);

	IF (was_found = false) THEN
		INSERT INTO session_failed (username, "when") VALUES (user_name, now());
		COMMIT;
		RAISE EXCEPTION 'Usuario y contraseña no son correctos'; -- cuando lanzamos una exception, se hace automaticamente un rollback de las modificaciones que intentamos hacer... A MENOS DE QUE ESTABLEZCAS EXPLICITAMENTE UN COMMIT (ASI COMO ARRIBA)
	END IF;

	-- actualizando al tabla de usuarios
	UPDATE "user" SET last_login = now() WHERE username = user_name;
	RAISE NOTICE 'Usuaario encontrado %', was_found;
	COMMIT; -- si todo sucede de manera correcta (con el update por ejemplo) el commit se sobreentiende

	-- recuerda que puedes o no colocar return pq es un procedimiento almacenado
END;
$$ LANGUAGE plpgsql;

CALL user_login('sebastian', '123456');


-- *** Triggers

-- creando mi procedure
CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER -- porque esta funcion será utilizada como por el trigger
AS $$
BEGIN
	INSERT INTO "session" (user_id, last_login) VALUES (NEW.id, now());
	-- con new.id estoy haciendo referencia a aquella tabla de la creacion del triger ("user"). por lo que estoy haciendo referencia al id del usuario
	-- basicamente representa la fila que se va a insertar o actualizar en la tabla a la que el trigger está asociado
	-- es decir, toma el id de la tabla usser de la fila que se actualizó
	RETURN NEW; -- representa la fila que se está insertando o actualizando en la tabla (en el caso de after... contiene los valores que acaban de ser insertados o actualizados en la tabla)
END;
$$ LANGUAGE plpgsql;

-- quiero insertar un registro en mi tabla "session"... si es que todo sale bien
CREATE OR REPLACE TRIGGER create_session_trigger AFTER UPDATE ON "user" -- crea este trigger que se ejecutará despues de una actualizacion en mi tabla "user"
FOR EACH ROW EXECUTE FUNCTION create_session_log(); -- por cada fila quiero ejecutar este procedimiento

-- un pequeño problema con esto es que si cambias de nombre por ejemplo a la tabla de usuario, el trigger se activara y se insertará un elemento en la tabla session

CALL user_login('sebastian', '123456'); -- este otro procedure realiza cambios en mi tabla "user"... por lo que hace que se dispare el trigger



-- *** Trigger When

-- aqui queremos arreglar el pequeño problema que sucede arriba

CREATE OR REPLACE TRIGGER create_session_trigger AFTER UPDATE ON "user"
FOR EACH ROW WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login) -- ahora si modificas un nombre en "users"... no se cumplirá el trigger por lo que no se insertará un registro en session
EXECUTE FUNCTION create_session_log(); -- por cada fila quiero ejecutar este procedimiento

CALL user_login('sebastian', '123456');


```
