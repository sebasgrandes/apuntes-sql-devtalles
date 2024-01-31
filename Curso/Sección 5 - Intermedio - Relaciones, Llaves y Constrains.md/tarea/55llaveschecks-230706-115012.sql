-- 1. Crear una llave primaria en city (id)
ALTER TABLE
    city
ADD
    PRIMARY KEY (id);
    
    
-- 2. Crear un check en population, para que no soporte negativos
ALTER TABLE
    city
ADD
    CHECK (population >= 0);
    
    
-- 3. Crear una llave primaria compuesta en "countrylanguage"
-- los campos a usar como llave compuesta son countrycode y language
ALTER TABLE
    countrylanguage
ADD
    PRIMARY KEY (countrycode, "language");
-- EN RESUMEN: lo que hace lo anterior es que no se tendrá esa combinacion de countrycode y language de forma repetida... eso es lo que lo hace unico y lo identifica como registro unico


-- 4. Crear check en percentage,
-- Para que no permita negativos ni números superiores a 100
ALTER TABLE
    countrylanguage
ADD
    CHECK (
        (percentage >= 0)
        AND (percentage <= 100)
    );

