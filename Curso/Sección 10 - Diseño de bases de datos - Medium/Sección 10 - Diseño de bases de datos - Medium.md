# Sección 10: Diseño de bases de datos - Medium

## Software para crear diagramas

10 programas para crear diagramas: https://gist.github.com/Klerith/17c487ecc2570f4ebf617c071bb88183

En esos programas se incluyen algunos simples de diagramación no más, y otros que permiten exportar el diagrama de entidad relación de SQL, entre ellos:

1. [**dbdiagram.io**](https://dbdiagram.io/home): tiene un tier gratuito muy bueno, pero tienes que codificar en una especie de lenguaje.
2. [Drawsql.app](https://drawsql.app/): es muy bueno, se puede realizar de forma visual, pero es limitado el tier gratuito. digamos que es mejor que db diagram en su version paga, pero en el gratuito, no.
3. [QuickDBD](https://www.quickdatabasediagrams.com/)

## Medium Database

-   Artículo de Medium: https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e
-   dbdiagram.io: https://dbdiagram.io/home

## Tabla de "comments"

https://www.postgresql.org/docs/current/queries-with.html

## Algunas notas

```SQL

-- limpiando lo de tableplus para iniciar desde cero
SELECT * FROM pg_extension; -- para saber que extensiones habiamos instalado
DROP EXTENSION "uuid-ossp";

DROP TABLE usersdual CASCADE; -- borra la tabla y aquellas que estan relacionadas

```

## Códigos (dbdiagram.io) de Práctica MIA

```SQL
// entidadees = tablas

// consejo cuando hay muchas tablas y relaciones: buscar aquellas de mayor peso... o aquellas más aisladas


// *** Tabla de "users"
Table users {
  user_id integer [pk, increment] // primary key, autoincrementado
  username varchar [not null, unique] // cuando ponemos el unique... también se crea un indice
  email varchar [not null, unique]
  name varchar [not null]
  role varchar [not null]
  gender varchar(10) [not null]
  avatar varchar
  created_at timestamp [default: 'now()']

  // asi también puedes crear un indice
  // indexes {
  //   (username)[unique]
  // }
}

// *** Tabla de "post"
Table posts {
  post_id integer [pk, increment]
  title varchar(200) [default: '']
  body text [default: '']
  og_image varchar
  slug varchar [not null, unique]
  published boolean
  created_by integer
}

// *** Tabla de "claps"

Table claps {
  clap_id integer [pk, increment]
  post_id integer
  user_id integer
  counter integer [default: 0]

  created_at timestamp

  indexes {
    (post_id, user_id)[unique] // creando un indice compuesto en esas 2 columnas
    (post_id)

  }
}

// *** Tabla de "comments"

Table comments {
  comment_id integer [pk, increment]
  post_id integer
  user_id integer [increment]
  comment_parent_id integer
  content text
  visible boolean
  created_at timestamp [default: 'now()']

  indexes {
    (post_id) // es un candidato para indice porque yo querré cargar todos los comentarios que estan en un post
    (visible) // indice que servirá para rapidamente cargar los posts que serán visibles
  }
}

// *** Tabla de "user_lists"
// solo listas (no posts)
Table user_list {
  user_list_id integer [pk, increment]
  user_id integer
  list_title varchar(100)

  indexes {
    (user_id, list_title)[unique]
    (user_id) // es un indice porque quiero rapidamente saber cuales son las listas que tiene esa persona
  }
}

// (entradas o posts) **favoritos** (que pueden pertenecer a una lista)
Table user_list_entry {
  user_list_entry integer [pk, increment]
  user_list_id integer
  post_id integer
}

// Preguntemos consultas posibles

// por ejemplo cantidad de comments -> visible (seria candidato para un index)

// creando la relación de forma manual: arrastra y suelta de campo a campo entre tablas
// esto quiere decir que: un usuario puede escribir muchos posts o que muchos posts pueden pertenecer a un usuario
Ref: "users"."user_id" < "posts"."created_by"

Ref: "posts"."post_id" < "claps"."post_id"

Ref: "users"."user_id" < "claps"."user_id"

Ref: "posts"."post_id" < "comments"."comment_id"

Ref: "users"."user_id" < "comments"."user_id"

Ref: "comments"."comment_id" < "comments"."comment_parent_id"

Ref: "users"."user_id" < "user_list"."user_id"

Ref: "user_list"."user_list_id" < "user_list_entry"."user_list_id"

Ref: "posts"."post_id" < "user_list_entry"."post_id"

Ref: "posts"."post_id" < "posts"."title"
```
