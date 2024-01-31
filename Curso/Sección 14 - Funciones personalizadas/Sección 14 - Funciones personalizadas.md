# Sección 14: Funciones personalizadas

plpgsql es lo que usaremos de lenguaje para crear funciones en postgressql

## Creando nuestra primera función

https://www.postgresql.org/docs/current/sql-createfunction.html

## Códigos de Práctica

```SQL

-- *** Creando nuestra primera función

-- creando mi funcion
CREATE OR REPLACE FUNCTION greet_employee (employee_name VARCHAR)
RETURNS VARCHAR
AS $$
-- DECLARE
BEGIN
	RETURN 'Hi ' || employee_name;
END;
$$
LANGUAGE plpgsql;

-- llamando mi funcion

SELECT greet_employee('sebas');

SELECT first_name, greet_employee(first_name), greet_employee('sebas') FROM employees;


-- *** Problema - Determinar un posible aumento

SELECT employee_id, first_name, salary, max_salary, max_salary - salary AS possible_raise
FROM employees
INNER JOIN jobs ON jobs.job_id = employees.job_id;

-- *** Función - max_raise

CREATE OR REPLACE FUNCTION max_raise(empl_id int)
RETURNS NUMERIC(8,2)
AS $$

-- declarando una variable
DECLARE
	possible_raise NUMERIC(8,2);

BEGIN
	SELECT max_salary - salary INTO possible_raise
	FROM employees
	INNER JOIN jobs ON jobs.job_id = employees.job_id
	WHERE employee_id = empl_id;
	RETURN possible_raise;
END;
$$ LANGUAGE plpgsql;


SELECT max_raise(206);

SELECT employee_id, first_name, max_raise(employee_id) FROM employees;

DROP FUNCTION max_raise_2;


-- *** Multiples queries y variables // IF, THEN, ELSE, END IF // Rowtype

CREATE OR REPLACE FUNCTION max_raise_2(empl_id int)
RETURNS NUMERIC(8,2)
AS $$
DECLARE
	selected_employee employees%rowtype;
	selected_job jobs%rowtype;
	possible_raise NUMERIC(8,2);

BEGIN
	-- tomar el puesto de trabajo y el salario
	SELECT * FROM employees INTO selected_employee
	WHERE employee_id = empl_id;

	-- tomar el max salary acorde a su job
	SELECT * FROM jobs INTO selected_job
	WHERE job_id = selected_employee.job_id;

	-- calculos
	possible_raise = selected_job.max_salary - selected_employee.salary;

	IF (possible_raise < 0) THEN
		RAISE EXCEPTION 'Persona con salario mayor max_salary id:%, %', selected_employee.employee_id, selected_employee.first_name;
	END IF;

	RETURN possible_raise;
END;
$$ LANGUAGE plpgsql;

SELECT employee_id, first_name, max_raise(employee_id), max_raise_2(employee_id) FROM employees
WHERE employee_id = 206;

```
