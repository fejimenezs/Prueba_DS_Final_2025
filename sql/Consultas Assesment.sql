-- English: Total revenue and transaction count by country
-- Español: Total de ingresos y conteo de transacciones por país
SELECT 
    r.pais AS region,
    SUM(v.total_ventas) AS total_ingresos,
    COUNT(v.id_venta) AS total_transacciones
FROM fact_ventas v
JOIN dim_regiones r ON v.id_region = r.id_region
GROUP BY r.pais
ORDER BY total_ingresos DESC;



-- English: Top 5 products by total revenue
-- Español: Los 5 productos que generan más ingresos
SELECT 
    p.producto,
    p.tipo_producto,
    SUM(v.total_ventas) AS ingresos_totales
FROM fact_ventas v
JOIN dim_productos p ON v.id_producto = p.id_producto
GROUP BY p.producto, p.tipo_producto
ORDER BY ingresos_totales DESC
LIMIT 5;




-- English: Revenue analysis by customer segment
-- Español: Análisis de ingresos por segmento de cliente
SELECT 
    c.segmento_cliente,
    SUM(v.total_ventas) AS total_ingresos,
    ROUND(AVG(v.total_ventas), 2) AS promedio_por_venta
FROM fact_ventas v
JOIN dim_clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.segmento_cliente
ORDER BY total_ingresos DESC;



-- English: Monthly sales performance
-- Español: Rendimiento mensual de ventas
SELECT 
    year, 
    month, 
    SUM(total_ventas) AS ingresos_mensuales
FROM fact_ventas
GROUP BY year, month
ORDER BY year DESC, month DESC;


-- English: Top 5 products by total revenue
-- Español: Top 5 productos con mayores ingresos generados
SELECT 
    p.producto, 
    p.tipo_producto,
    SUM(v.total_ventas) AS monto_total_vendido
FROM fact_ventas v
JOIN dim_productos p ON v.id_producto = p.id_producto
GROUP BY p.producto, p.tipo_producto
ORDER BY monto_total_vendido DESC
LIMIT 5;



-- English: Average ticket size by customer segment
-- Español: Ticket promedio de venta por segmento de cliente
SELECT 
    c.segmento_cliente,
    ROUND(AVG(v.total_ventas), 2) AS ticket_promedio,
    COUNT(v.id_venta) AS total_transacciones
FROM fact_ventas v
JOIN dim_clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.segmento_cliente
ORDER BY ticket_promedio DESC;


-- English: Identify customers with no sales transactions (Potential leads or data gaps)
-- Español: Identificar clientes que existen en la dimensión pero no tienen ventas registradas
SELECT 
    c.id_cliente,
    c.tipo_cliente,
    c.segmento_cliente
FROM dim_clientes c
LEFT JOIN fact_ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;



-- English: Total sales segmented by country and product category
-- Español: Ventas totales segmentadas por país y categoría de producto
SELECT 
    r.pais, 
    p.tipo_producto, 
    SUM(v.total_ventas) AS ventas_totales
FROM fact_ventas v
JOIN dim_regiones r ON v.id_region = r.id_region
JOIN dim_productos p ON v.id_producto = p.id_producto
GROUP BY r.pais, p.tipo_producto
ORDER BY r.pais ASC, ventas_totales DESC;



-- English: Ranking customers by total spending using DENSE_RANK
-- Español: Ranking de clientes por gasto total usando DENSE_RANK
SELECT 
    v.id_cliente,
    SUM(v.total_ventas) AS total_gastado,
    DENSE_RANK() OVER (ORDER BY SUM(v.total_ventas) DESC) AS ranking_ventas
FROM fact_ventas v
GROUP BY v.id_cliente;



-- English: Year-over-Year (YoY) sales comparison
-- Español: Comparación de ventas año tras año (YoY)
WITH ventas_anuales AS (
    SELECT 
        year, 
        SUM(total_ventas) AS ventas_actuales
    FROM fact_ventas
    GROUP BY year
)
SELECT 
    year,
    ventas_actuales,
    LAG(ventas_actuales) OVER (ORDER BY year) AS ventas_anio_anterior,
    ROUND(((ventas_actuales - LAG(ventas_actuales) OVER (ORDER BY year)) / 
           LAG(ventas_actuales) OVER (ORDER BY year) * 100), 2) AS porcentaje_crecimiento_yoy
FROM ventas_anuales;








-- English: Market share (percentage) of each category over total sales
-- Español: Porcentaje de participación de cada categoría sobre el total de ventas
SELECT 
    p.tipo_producto,
    SUM(v.total_ventas) AS ventas_categoria,
    ROUND(SUM(v.total_ventas) * 100.0 / SUM(SUM(v.total_ventas)) OVER (), 2) AS porcentaje_participacion
FROM fact_ventas v
JOIN dim_productos p ON v.id_producto = p.id_producto
GROUP BY p.tipo_producto
ORDER BY porcentaje_participacion DESC;




