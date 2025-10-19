CREATE EXTENSION IF NOT EXISTS odbc_fdw;

CREATE SERVER maria_pi_server 
    FOREIGN DATA WRAPPER odbc_fdw 
    OPTIONS (
        dsn 'MariaDB_RPi' -- NOMBRE DEL DSN DE SISTEMA DE WINDOWS
    );


CREATE USER MAPPING FOR postgres 
    SERVER maria_pi_server;

CREATE FOREIGN TABLE cliente_remoto (
    cli_id INTEGER NOT NULL,
    cli_nombre VARCHAR(100) NOT NULL,
    cli_saldo NUMERIC(12,2) NOT NULL,
    cli_limitecredito NUMERIC(12,2) NOT NULL,
    cli_descuento NUMERIC(5,2) NOT NULL
)
SERVER maria_pi_server
OPTIONS (table 'cliente');

CREATE FOREIGN TABLE direcciones_remoto (
    dir_id INTEGER NOT NULL,
    dir_idcliente INTEGER NOT NULL,
    dir_calle VARCHAR(100) NOT NULL,
    dir_ciudad VARCHAR(50) NOT NULL,
    dir_region VARCHAR(50) NOT NULL,
    dir_pais VARCHAR(50) NOT NULL
)
SERVER maria_pi_server
OPTIONS (table 'direcciones');

CREATE FOREIGN TABLE pedido_remoto (
    ped_id INTEGER NOT NULL,
    ped_idcliente INTEGER NOT NULL,
    ped_direccion INTEGER NOT NULL,
    ped_fechapedido DATE NOT NULL,
    ped_estado VARCHAR(20) NOT NULL
)
SERVER maria_pi_server
OPTIONS (table 'pedido');

CREATE FOREIGN TABLE detalle_pedido_remoto (
    detped_id INTEGER NOT NULL,
    detped_idpedido INTEGER NOT NULL,
    detped_idarticulo INTEGER NOT NULL,
    detped_cantidad INTEGER NOT NULL,
    detped_precio NUMERIC(12,2) NOT NULL,
    detped_descuento NUMERIC(5,2) NOT NULL
)
SERVER maria_pi_server
OPTIONS (table 'detalle_pedido');



SELECT
    a.art_nombre AS "Artículo Local",
    SUM(af.artfab_existencias) AS "Stock Total Local",
    c.cli_nombre AS "Cliente Remoto Ejemplo" 
FROM
    articulo a  
JOIN
    articulo_fabrica af ON a.art_id = af.artfab_idarticulo
CROSS JOIN
    cliente_remoto c
GROUP BY
    a.art_nombre, c.cli_nombre
ORDER BY
    a.art_nombre
LIMIT 10;


SELECT * FROM ARTICULO;
SELECT
    *
FROM
    detalle_pedido_remoto
LIMIT 10; 
SELECT
    a.art_nombre AS "Producto Local",
    dpr.detped_idpedido AS "ID de Pedido Remoto",
    dpr.detped_cantidad AS "Cantidad Vendida",
    dpr.detped_precio AS "Precio de Venta Remoto"
FROM
    articulo a 
JOIN
    detalle_pedido_remoto dpr 
    ON a.art_id = dpr.detped_idarticulo