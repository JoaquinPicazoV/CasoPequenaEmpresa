INSERT INTO cliente (cli_nombre, cli_limitecredito) VALUES
('Cliente A', 2000000),
('Cliente B', 1500000);

INSERT INTO direcciones VALUES
(1, 1, 'Av. Los Andes 123', 'Puerto Montt', 'Sur', 'Chile'),
(2, 1, 'Calle del Mar 45', 'Valdivia', 'Sur', 'Chile'),
(1, 2, 'Av. Japón 900', 'Santiago', 'Centro', 'Chile');

INSERT INTO pedido (ped_idcliente, ped_direccion) VALUES
(1, 1),
(2, 1);

INSERT INTO detalle_pedido (detped_idpedido, detped_idarticulo, detped_cantidad, detped_precio)
VALUES
(1, 101, 10, 3500),
(2, 102, 5, 2000);