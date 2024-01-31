-- 1. Cuantos Post hay - 1050
SELECT * FROM posts;
SELECT count(*) as total_posts, 'Cantidad de Posts Totales' as annotation FROM posts;

-- 2. Cuantos Post publicados hay - 543
SELECT * FROM posts;
SELECT count(*) as total_posts, 'Cantidad de Posts Publicados' as annotation FROM posts WHERE published=TRUE;

-- 3. Cual es el Post mas reciente
-- 544 - nisi commodo officia...2024-05-30 00:29:21.277
SELECT * FROM posts;
SELECT MAX(created_at) FROM posts;
SELECT * FROM posts ORDER BY created_at DESC LIMIT 1;

-- 4. Quiero los 10 usuarios con más post, cantidad de posts, id y nombre
/*
4	1553	Jessie Sexton
3	1400	Prince Fuentes
3	1830	Hull George
3	470	Traci Wood
3	441	Livingston Davis
3	1942	Inez Dennis
3	1665	Maggie Davidson
3	524	Lidia Sparks
3	436	Mccoy Boone
3	2034	Bonita Rowe
*/
SELECT * FROM posts;
SELECT count(*) as cantidad_de_posts, a.created_by as creado_por_id, b.user_id as creado_por_id2, b."name" FROM posts a
INNER JOIN users b ON a.created_by = b.user_id
GROUP BY creado_por_id, creado_por_id2
ORDER BY cantidad_de_posts DESC
LIMIT 10;


-- 5. Quiero los 5 post con más "Claps" sumando la columna "counter"
/*
692	sit excepteur ex ipsum magna fugiat laborum exercitation fugiat
646	do deserunt ea
542	do
504	ea est sunt magna consectetur tempor cupidatat
502	amet exercitation tempor laborum fugiat aliquip dolore
*/
SELECT * FROM claps;
SELECT SUM(a.counter) as suma_de_cantidad_claps, a.post_id, b.post_id, b.title FROM claps a
INNER JOIN posts b ON a.post_id = b.post_id
GROUP BY a.post_id, b.post_id
ORDER BY suma_de_cantidad_claps DESC
LIMIT 5;

-- 6. Top 5 de personas que han dado más claps (voto único no acumulado ) *count
/*
7	Lillian Hodge
6	Dominguez Carson
6	Marva Joyner
6	Lela Cardenas
6	Rose Owen
*/
SELECT * FROM claps;
SELECT DISTINCT COUNT(*) as cantidad_claps, a.user_id, b.user_id, b.name FROM claps a
INNER JOIN users b ON a.user_id = b.user_id
GROUP BY a.user_id, b.user_id
ORDER BY cantidad_claps DESC
LIMIT 5;

-- 7. Top 5 personas con votos acumulados (sumar counter)
/*
437	Rose Owen
394	Marva Joyner
386	Marquez Kennedy
379	Jenna Roth
364	Lillian Hodge
*/
SELECT * FROM claps;
SELECT DISTINCT SUM(a.counter) as cantidad_claps, a.user_id, b.user_id, b.name FROM claps a
INNER JOIN users b ON a.user_id = b.user_id
GROUP BY a.user_id, b.user_id
ORDER BY cantidad_claps DESC
LIMIT 5;


-- 8. Cuantos usuarios NO tienen listas de favoritos creada
-- 329

SELECT count(*), 'Sin favoritos' as annotation FROM user_lists a
RIGHT OUTER JOIN users b ON a.user_id = b.user_id
WHERE a.user_list_id IS NULL;

-- 9. Quiero el comentario con id 1
-- Y en el mismo resultado, quiero sus respuestas (visibles e invisibles)
-- Tip: union
/*
1	    648	1905	elit id...
3058	583	1797	tempor mollit...
4649	51	1842	laborum mollit...
4768	835	1447	nostrud nulla...
*/

(SELECT * FROM comments WHERE comment_id=1)
UNION
(SELECT * FROM comments WHERE comment_parent_id=1 ORDER BY created_at ASC);


-- ** 10. Avanzado
-- Investigar sobre el json_agg y json_build_object
-- Crear una única linea de respuesta, con las respuestas
-- del comentario con id 1 (comment_parent_id = 1)
-- Mostrar el user_id y el contenido del comentario

-- Salida esperada:
/*
"[{""user"" : 1797, ""comment"" : ""tempor mollit aliqua dolore cupidatat dolor tempor""}, {""user"" : 1842, ""comment"" : ""laborum mollit amet aliqua enim eiusmod ut""}, {""user"" : 1447, ""comment"" : ""nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat""}]"
*/

-- !! solucion ideal
SELECT json_agg(json_build_object(
	'user', comments.user_id,
	'comment', comments.content
)) FROM comments WHERE comment_parent_id = 1;

WITH comments AS (SELECT user_id as user, content as comment FROM comments WHERE comment_parent_id=1) SELECT JSON_AGG(comments.*) as comentarios FROM comments ;
-- [{"user":1797,"comment":"tempor mollit aliqua dolore cupidatat dolor tempor"}, {"user":1842,"comment":"laborum mollit amet aliqua enim eiusmod ut"}, {"user":1447,"comment":"nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat"}]

SELECT JSON_AGG(json_build_object) as comentarios FROM (SELECT json_build_object('user', user_id, 'comment', content) FROM comments WHERE comment_parent_id=1) as alias_cualquiera;
-- [{"user" : 1797, "comment" : "tempor mollit aliqua dolore cupidatat dolor tempor"}, {"user" : 1842, "comment" : "laborum mollit amet aliqua enim eiusmod ut"}, {"user" : 1447, "comment" : "nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat"}]


-- pruebas

SELECT user_id, content FROM comments WHERE comment_parent_id=1 ORDER BY created_at ASC;
SELECT JSON_AGG(comments.*) FROM comments WHERE comment_parent_id=1; -- solucion en bruto
SELECT user_id, JSON_AGG(content) as hola FROM comments WHERE comment_parent_id=1 GROUP BY user_id;

SELECT json_build_object(1, 'a', true, row(2, 'b', false));
SELECT json_build_object('user', user_id, 'comment', content) FROM comments WHERE comment_parent_id=1;


-- ** 11. Avanzado
-- Listar todos los comentarios principales (no respuestas) 
-- Y crear una columna adicional "replies" con las respuestas en formato JSON

-- !! solucion ideal
SELECT a.*,
	(SELECT json_agg(json_build_object(
	'user', b.user_id,
	'comment', b.content
	))
	FROM comments b WHERE b.comment_parent_id = a.comment_id) as replies
FROM comments a WHERE comment_parent_id IS NULL;


SELECT a.comment_id as id_comentario_padre, a."content" as cometario_padre,
	(SELECT JSON_AGG(json_build_object) as comentarios FROM (SELECT json_build_object('user', user_id, 'comment', content) FROM comments WHERE comment_parent_id=a.comment_id) as alias_cualquiera) as comentarios_hijos
FROM "comments" a
WHERE a.comment_parent_id IS NULL;
/*
[{"user" : 1797, "comment" : "tempor mollit aliqua dolore cupidatat dolor tempor"},
{"user" : 1842, "comment" : "laborum mollit amet aliqua enim eiusmod ut"},
{"user" : 1447, "comment" : "nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat"}]
*/

-- pruebas
SELECT a.comment_id, a."content" FROM "comments" a WHERE a.comment_parent_id IS NULL; -- seleccion de comentarios padres
SELECT b.comment_id, b.content, b.comment_parent_id FROM comments b WHERE b.comment_parent_id IS NOT NULL; -- seleccion de comentarios hijos

-- solucion en bruto
SELECT a.comment_id, a."content", (SELECT JSON_AGG(b.*) FROM comments b WHERE b.comment_parent_id=a.comment_id) as raaaa FROM "comments" a WHERE a.comment_parent_id IS NULL;
/*
[{"comment_id":3058,"post_id":583,"user_id":1797,"content":"tempor mollit aliqua dolore cupidatat dolor tempor","created_at":"2022-05-13T01:06:24.682","visible":true,"comment_parent_id":1},
{"comment_id":4649,"post_id":51,"user_id":1842,"content":"laborum mollit amet aliqua enim eiusmod ut","created_at":"2023-01-23T14:31:46.988","visible":false,"comment_parent_id":1},
{"comment_id":4768,"post_id":835,"user_id":1447,"content":"nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat","created_at":"2021-02-25T18:02:49.546","visible":true,"comment_parent_id":1}]
*/