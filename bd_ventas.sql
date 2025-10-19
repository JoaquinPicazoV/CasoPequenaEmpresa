CREATE DATABASE IF NOT EXISTS ventas;

USE ventas;

CREATE TABLE cliente (
  cli_id INT AUTO_INCREMENT PRIMARY KEY,
  cli_nombre VARCHAR(100) NOT NULL,
  cli_saldo NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (cli_saldo >= 0),
  cli_limitecredito NUMERIC(12,2) NOT NULL CHECK (cli_limitecredito BETWEEN 0 AND 3000000),
  cli_descuento NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (cli_descuento BETWEEN 0 AND 100)
);

CREATE TABLE direcciones (
  dir_id INT NOT NULL,
  dir_idcliente INT NOT NULL,
  dir_calle VARCHAR(100) NOT NULL,
  dir_ciudad VARCHAR(50) NOT NULL,
  dir_region VARCHAR(50) NOT NULL,
  dir_pais VARCHAR(50) NOT NULL,
  PRIMARY KEY (dir_id, dir_idcliente),
  FOREIGN KEY (dir_idcliente) REFERENCES cliente(cli_id)
);

CREATE TABLE pedido (
  ped_id INT AUTO_INCREMENT PRIMARY KEY,
  ped_idcliente INT NOT NULL,
  ped_direccion INT NOT NULL,
  ped_fechapedido DATE NOT NULL DEFAULT CURRENT_DATE(), 
  ped_estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
  FOREIGN KEY (ped_idcliente) REFERENCES cliente(cli_id),
  FOREIGN KEY (ped_direccion, ped_idcliente) REFERENCES direcciones (dir_id, dir_idcliente)
);

CREATE TABLE detalle_pedido (
  detped_id INT AUTO_INCREMENT PRIMARY KEY,
  detped_idpedido INT NOT NULL,
  detped_idarticulo INT NOT NULL,
  detped_cantidad INT NOT NULL CHECK (detped_cantidad > 0),
  detped_precio NUMERIC(12,2) NOT NULL CHECK (detped_precio > 0),
  detped_descuento NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (detped_descuento BETWEEN 0 AND 100),
  FOREIGN KEY (detped_idpedido) REFERENCES pedido(ped_id)
);