-- 0) Clean
DROP VIEW IF EXISTS vista_pedido_articulos;
DROP VIEW IF EXISTS vista_stock_por_fabrica;

DROP SCHEMA IF EXISTS fdw_abastecimiento CASCADE;

DROP USER MAPPING IF EXISTS FOR postgres SERVER abastecimiento_srv;
DROP SERVER IF EXISTS abastecimiento_srv CASCADE;

-- 1) HABILITAR FDW
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2) DEFINIR SERVIDOR REMOTO
CREATE SERVER abastecimiento_srv
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (
    host '192.168.1.82',
    dbname 'postgres',
    port '5432'
  );

-- 
-- 3) MAPEAR USUARIO LOCAL -> USUARIO REMOTO
-- 
CREATE USER MAPPING FOR postgres
  SERVER abastecimiento_srv
  OPTIONS (
    user 'ext_user',
    password 'postgres'
  );

-- 4) IMPORTAR TABLAS REMOTAS COMO FOREIGN TABLES
CREATE SCHEMA IF NOT EXISTS fdw_abastecimiento;

IMPORT FOREIGN SCHEMA public
  FROM SERVER abastecimiento_srv
  INTO fdw_abastecimiento
  OPTIONS (
    import_default 'false', 
    import_collate  'true',
    import_not_null 'true'
  );

-- 5) VISTAS UNIFICADAS

-- 5.1 Stock por fábrica
CREATE VIEW vista_stock_por_fabrica AS
SELECT
  f.fab_id,
  f.fab_nombre,
  a.art_id,
  a.art_nombre,
  af.artfab_existencias
FROM fdw_abastecimiento.articulo_fabrica af
JOIN fdw_abastecimiento.articulo a ON a.art_id = af.artfab_idarticulo
JOIN fdw_abastecimiento.fabrica  f ON f.fab_id = af.artfab_idfabrica;

-- 5.2 Pedidos con nombre de artículo
CREATE VIEW vista_pedido_articulos AS
SELECT
  p.ped_id,
  c.cli_nombre,
  a.art_nombre,
  d.detped_cantidad,
  d.detped_precio,
  d.detped_cantidad * d.detped_precio AS subtotal,
  p.ped_fechapedido
FROM detalle_pedido d
JOIN pedido p ON p.ped_id = d.detped_idpedido
JOIN cliente c ON c.cli_id = p.ped_idcliente
JOIN fdw_abastecimiento.articulo a ON a.art_id = d.detped_idarticulo;

-- 7) CONSULTAS DE VALIDACIÓN (cumplimiento del enunciado)

-- 7.1 Clientes y sus direcciones (varias por cliente)
SELECT c.cli_id, c.cli_nombre, d.dir_id, d.dir_calle, d.dir_ciudad, d.dir_region, d.dir_pais
FROM cliente c
JOIN direcciones d ON (d.dir_idcliente = c.cli_id)
ORDER BY c.cli_id, d.dir_id;

-- 7.2 Ningún cliente supera el límite de crédito (3.000.000)
SELECT cli_id, cli_nombre, cli_limitecredito,
       CASE WHEN cli_limitecredito <= 3000000 THEN 'OK' ELSE 'ERROR' END AS valida
FROM cliente
ORDER BY cli_limitecredito DESC;

-- 7.3 Prueba: dirección no pertenece al cliente
INSERT INTO pedido (ped_idcliente, ped_direccion, ped_fechapedido)
VALUES (2, 999, CURRENT_DATE); 

-- 7.4 Prueba: límite de crédito supera 3.000.000
INSERT INTO cliente (cli_id, cli_nombre, cli_limitecredito, cli_descuento)
VALUES (11, 'Tomás Vidal', 3500000, 5);

-- 7.5 Pedidos con nombre de artículo (vista unificada)
SELECT * FROM vista_pedido_articulos ORDER BY ped_id;

-- 7.6 Existencias por artículo y fábrica
SELECT f.fab_id, f.fab_nombre, a.art_id, a.art_nombre, af.artfab_existencias
FROM fdw_abastecimiento.articulo_fabrica af
JOIN fdw_abastecimiento.fabrica  f ON f.fab_id = af.artfab_idfabrica
JOIN fdw_abastecimiento.articulo a ON a.art_id = af.artfab_idarticulo
ORDER BY f.fab_id, a.art_id;

-- 7.7 Total de artículos que provee cada fábrica
SELECT f.fab_id, f.fab_nombre, COUNT(DISTINCT af.artfab_idarticulo) AS articulos_totales
FROM fdw_abastecimiento.articulo_fabrica af
JOIN fdw_abastecimiento.fabrica f ON f.fab_id = af.artfab_idfabrica
GROUP BY f.fab_id, f.fab_nombre
ORDER BY f.fab_id;

-- 7.8 Ventas totales por cliente (sumando subtotales)
SELECT c.cli_id, c.cli_nombre,
       SUM(d.detped_cantidad * d.detped_precio) AS total_vendido
FROM pedido p
JOIN detalle_pedido d ON d.detped_idpedido = p.ped_id
JOIN cliente c ON c.cli_id = p.ped_idcliente
GROUP BY c.cli_id, c.cli_nombre
ORDER BY total_vendido DESC NULLS LAST;

-- 7.9 Todos los articulos con sus fabricas actuales
SELECT a.art_nombre, f.fab_nombre, af.artfab_existencias
FROM fdw_abastecimiento.articulo_fabrica af
JOIN fdw_abastecimiento.articulo a ON a.art_id = af.artfab_idarticulo
JOIN fdw_abastecimiento.fabrica f ON f.fab_id = af.artfab_idfabrica
WHERE af.artfab_tipo_relacion = 'actual'
ORDER BY f.fab_nombre;

-- 7.10 Fabricas alternativas registradas
SELECT a.art_nombre, f.fab_nombre AS fabrica_alternativa
FROM fdw_abastecimiento.articulo_fabrica af
JOIN fdw_abastecimiento.articulo a ON a.art_id = af.artfab_idarticulo
JOIN fdw_abastecimiento.fabrica f ON f.fab_id = af.artfab_idfabrica
WHERE af.artfab_tipo_relacion = 'alternativa';

