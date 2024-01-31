# Sección 15: Stored Procedures

los procedimientos almacenados no necesariamente retornan un valor. se utilizan para centralizar un procedimiento.  
basicamente es código que queremos ejecutar de forma secuencial desde el lado de la base de datos.

## Códigos de Práctica

```SQL

-- *** Función que regresa una tabla

SELECT country_id, country_name, region_name FROM countries
INNER JOIN regions ON countries.region_id = regions.region_id;

CREATE OR REPLACE FUNCTION country_region()
RETURNS TABLE (id CHARACTER(2), name VARCHAR(40), region VARCHAR(25))
AS $$
BEGIN
	RETURN query
		SELECT country_id, country_name, region_name FROM countries
		INNER JOIN regions ON countries.region_id = regions.region_id;
	
END;
$$ LANGUAGE plpgsql;

SELECT * FROM country_region();


-- ** Procedimientos almacenados

-- POR EJEMPLO le damos un procedimiento almacenado a un junior para que no maneje directamente sobre mi db

CREATE OR REPLACE PROCEDURE insert_region_proc(INT, VARCHAR)
AS $$
BEGIN
	INSERT INTO regions(region_id, region_name)
	VALUES($1, $2);
	
	raise notice 'Variable 1: %, %', $1, $2
	
-- 	ROLLBACK; -- esto se usa para que no se haga el procedimiento o vuelva... se hecha para atrás
	COMMIT;

END;
$$ LANGUAGE plpgsql;

CALL insert_region_proc(6, 'Aentral America');

SELECT * FROM regions;


--  *** Procedimiento de aumento salarial

CREATE OR REPLACE FUNCTION max_raise( empl_id int )
returns NUMERIC(8,2) as $$

DECLARE
	possible_raise NUMERIC(8,2);

BEGIN
	
	select 
		max_salary - salary into possible_raise
	from employees
	INNER JOIN jobs on jobs.job_id = employees.job_id
	WHERE employee_id = empl_id;

	if ( possible_raise < 0 ) THEN
		possible_raise = 0;
	end if;

	return possible_raise;

END;
$$ LANGUAGE plpgsql;


SELECT
    current_date as date,
    salary,
    max_raise(employee_id),
    max_raise(employee_id) * 0.05 as amount,
    5 as percentage
FROM
    employees;

-- *** Creación del procedimiento

CREATE OR REPLACE PROCEDURE controlled_raise(percentage NUMERIC)
AS $$
DECLARE 
	real_percentage NUMERIC(8,2);
	total_employees INT;
BEGIN
	real_percentage = percentage/100;
	
	-- mantener el historico (insertamos en la tabla raise_history)
	INSERT INTO raise_history(date, employee_id, base_salary, amount, percentage)
	SELECT
	    current_date as date,
	    employee_id,
	    salary,
	    max_raise(employee_id) * real_percentage as amount,
	    percentage
	FROM
	    employees;
	
	-- impactar (actualizamos) la tabla de empleados con los nuevos salarios
	UPDATE employees
	SET salary = salary + (max_raise(employee_id) * real_percentage);
	
	COMMIT;
	SELECT count(*) INTO total_employees FROM employees; -- contamos los registros afectados
	raise notice 'Afectados % empleados', total_employees; -- muestra un aviso
END;
$$ LANGUAGE plpgsql;


CALL controlled_raise(10);

SELECT * FROM employees;

```
