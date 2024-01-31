# Sección 12: Diseño de bases de datos - Más ejercicios

## Exposición sobre diseños

Preguntémonos:

-   ¿Cuál es el objetivo de la misma?
-   ¿Cómo usaremos la base de datos?

En general un buen diseño

-   Minimizar la redundancia.
-   Proteger la precisión.
-   Ser accesible.
-   Cumplir las expectativas.

Determinar los objetivos

-   Investigar previamente sobre diseños similares.
-   Traiga las partes interesadas.
-   Empápate del tema objetivo.

Principios a seguir

-   Mantenla simple.
-   Usa estandarización. -> mismos nombres de tabla...
-   Considera futuras modificaciones.
-   Mantén la deuda técnica a raya.
-   Normalizar la data.
-   Diseña a largo plazo.
-   Crea documentación y diagramas.
-   Prueba tu diseño.
-   No uses abreviaturas \*. (Internationalization por i18n)
-   Se recomienda nombres tablas en singular.
-   No re-inventes la rueda.
-   Usa lo que el motor de base de datos te ofrece.
-   Reglas, checks, llaves, indices, para evitar basura.
-   Mantén la privacidad como prioridad. -> encriptadas
-   Nombres en inglés y evitar caracteres especiales.
-   Todo en minúscula sin espacios.

## Diseños de BD y buenas prácticas - Parte 2

Principios a seguir

-   Mantén la base de datos en su propio servidor. -> separado del backend por ejemplo
-   Mantén un modelado bajo versiones.
-   Establece el tipo apropiado y precisión adecuada.
-   No confíes en identificadores de terceros. -> no debes de tener esos identificadores como llaves primarias en tu db. controla tu llave primaria!
-   Defina las llaves foráneas y relaciones.
-   Si el esquema es muy grande, particiónalo.
-   Evita nombres reservados. "user", "table", "create"

Ideas a tener en mente

-   Los nombres de tablas y campos vivirán más que las aplicaciones. -> el backend puede desecharse una y otra vez, pero el buen diseño de db, perdura en el tiempo.
-   Los nombres son contratos.
-   La base de datos gobierna sobre los demás. -> la db debe gobernar las aplicaciones... no el backend por ejemplo.

Relaciones en singular: Tablas, vistas y cualquier relación en singular.

-   Es posible tener una relación uno a uno, ¿seguiría esto siendo plural?
-   En inglés, hay palabras que no tienen forma plural. "fish", "species", "series"
-   Mucho software trabaja siguiendo esta regla de singular, y se usar mejor de esa forma. (Sentido semántico)

Nombrado explícito: Evitar redundancia y lectura adicional

-   person_id vs id
-   Las llaves foráneas deben de ser una combinación, por ejemplo: `team_id, post_id`
-   Indices deben de ser explícitos: person_idx_first_name_last_name

Ideas finales

-   Si ya hay una estructura creada que sigue otras reglas, sigamos esas reglas. \* -> si la db tiene espacios, esta en español, solo sigue con ello. es realmente dificil cambiar esa estructura, porque impacta en todas tus apps
-   No mezclemos ideologías si no pensamos cambiar todo.
-   Estos pasos son útiles para empezar nuevos diseños.

## Idea Airbnb

https://drawsql.app/templates/airbnb

## Códigos de Práctica

### Warehouse DB

```SQL

// *** Diseño - Warehouse DB

table product {
  id int [pk, increment]
  serial varchar // como depende de 3eros, no deberia ser mi llave primaria
  name varchar(200)
  merchant int // el mercante puede ser una tabla adicional... porque puede haber varios que tengan productos
  price float(8,2)
  status product_status // solo le pones status porque se entiende que pertenece a mi tabla product, dado que estamos en ella
  stock int

  created_at timestamp [default: 'now()']
}

enum product_status {
  in_stock
  out_of_stock
  running_low
}

// *** Diseño de tabla "merchant"

table merchant {
  id int [pk, increment]
  name varchar
  country int

  created_at timestamp [default: 'now()']
}

table country {
  id int [pk, increment]
  name varchar
}

// Diseño de ordenes de compra

// esto es solo una "orden"
table order {
  id int [pk, increment]
  status order_status
  user_id int
  total float(12,2)

  created_at timestamp [default: 'now()']
}

enum order_status {
  placed
  confirm
  processed
  completed
}

// esto son los articulos de la orden
table order_item {
  id int [pk, increment]
  order_id int // una orden (de order) puede tener muchos articulos (order_item)
  product_id int
  quantity int
}


Ref: "merchant"."id" < "product"."merchant"

Ref: "country"."id" < "merchant"."country"

Ref: "merchant"."id" < "order"."user_id"

Ref: "order"."id" < "order_item"."order_id"

Ref: "product"."id" < "order_item"."product_id"

```

### Twitter

```SQL

// Tabla de usuario

table user {
  id int [pk, increment]
  name varchar(100)
  slug varchar(50)
  email varchar[unique]

  bio text
  country int
  work varchar(10)
  born_at timestamp

  created_at timestamp [default: 'now()']
}

table country {
  id int [pk, increment]
  name varchar(10)
}

// Tabla de tweets
// suponiendo que cada tweet tiene un solo hilo (una sola respuesta)
table tweet {
  id int [pk, increment]
  content varchar(150)

  user_id int
  retweets int
  likes int
  shares int
  created_at timestamp [default: 'now()']
}

// Tabla de following/followers

table follower {
  id int [pk, increment]
  follower_id int
  followed_id int
}

Ref: "country"."id" < "user"."country"

Ref: "user"."id" < "tweet"."user_id"

Ref: "user"."id" < "follower"."follower_id"

Ref: "user"."id" < "follower"."followed_id"

```
