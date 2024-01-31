# Sección 8: Queries - Fechas, intervalos y funciones sobre fechas

## Funciones básicas de fechas

https://www.postgresql.org/docs/8.1/functions-datetime.html

PostgresTutorial - Date Functions: https://www.postgresqltutorial.com/postgresql-date-functions/postgresql-date_part/

## Códigos de Práctica

```SQL

-- *** Funciones básicas de fechas

SELECT
    now(),
    CURRENT_DATE,
    CURRENT_TIME,
    CURRENT_ROLE,
    DATE_PART('days', now()),
    DATE_PART('months', now()),
    DATE_PART('hours', now()),
    DATE_PART('minutes', now()),
    DATE_PART('seconds', now());
    

-- *** Consultas sobre fechas

SELECT first_name, email, hire_date FROM employees WHERE hire_date > '1999-01-01' ORDER BY hire_date DESC; -- se sobreentiende que es una fecha, sin embargo, también puedes ponerle DATE('1999-01-01')

SELECT MAX(hire_date), MIN(hire_date) FROM employees;

SELECT first_name, email, hire_date FROM employees WHERE hire_date BETWEEN '1997-01-01' AND '1999-01-01'  ORDER BY hire_date DESC;


-- *** Intervalos
-- sumando
SELECT
    MAX(hire_date),
    MAX(hire_date) + INTERVAL '10 days' as days,
    MAX(hire_date) + INTERVAL '10 months' as months,
    MAX(hire_date) + INTERVAL '10 years' as years,
    MAKE_INTERVAL(YEARS:=date_part('years', now())::integer),
    MAX(hire_date) + MAKE_INTERVAL(YEARS:=24)
    
FROM
    employees;


-- *** Diferencia entre fechas y actualizaciones

SELECT
	hire_date,
	MAKE_INTERVAL(YEARS:=2023 - EXTRACT(YEARS from hire_date)::integer) as manual,
	MAKE_INTERVAL(YEARS:= date_part('years', CURRENT_DATE)::INTEGER - EXTRACT(YEARS FROM hire_date)::integer) as computed
FROM employees;


SELECT hire_date, hire_date + MAKE_INTERVAL(YEARS:=24) from employees;

UPDATE employees SET hire_date=(hire_date + MAKE_INTERVAL(YEARS:=24));


-- *** Cláusula CASE - THEN

SELECT first_name, email, hire_date,
	CASE
		WHEN hire_date > now() - INTERVAL '1 year' THEN '1 año' 
		WHEN hire_date > now() - INTERVAL '3 year' THEN '3 años'
		WHEN hire_date > now() - INTERVAL '6 year' THEN '6 años'
		ELSE '+ 6 años'
	END as años_antiguedad
FROM employees
ORDER BY hire_date DESC;

```