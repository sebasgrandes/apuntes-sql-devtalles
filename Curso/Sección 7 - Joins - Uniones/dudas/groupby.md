# para que sirve el group by en sql, dame un ejemplo

`GROUP BY` en SQL es una cláusula que se utiliza para agrupar filas con valores idénticos en una o más columnas. Esto es particularmente útil en consultas con funciones agregadas como `COUNT()`, `SUM()`, `AVG()`, `MIN()`, y `MAX()`, donde se desea calcular un valor agregado para cada grupo de filas.

Aquí tienes un ejemplo para ilustrarlo mejor:

Supongamos que tienes una tabla llamada `Ventas` con las siguientes columnas: `ID_Venta`, `Fecha`, `ID_Producto`, y `Cantidad`. Si deseas saber la cantidad total vendida de cada producto, puedes usar `GROUP BY` de la siguiente manera:

```sql
SELECT ID_Producto, SUM(Cantidad) AS Cantidad_Total
FROM Ventas
GROUP BY ID_Producto;
```

En este ejemplo, el `GROUP BY` agrupa los registros por `ID_Producto`. Luego, para cada grupo de `ID_Producto`, la función `SUM(Cantidad)` calcula la suma total de la columna `Cantidad`. El resultado será una lista de productos con la cantidad total vendida de cada uno.
