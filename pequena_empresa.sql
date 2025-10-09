CREATE DATABASE pequena_empresa;
USE pequena_empresa;


-- Tabla CLIENTE
CREATE TABLE cliente (
    cli_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_saldo DECIMAL(12,2) NOT NULL DEFAULT 0,
    cli_limitecredito DECIMAL(12,2) NOT NULL CHECK (cli_limitecredito <= 3000000),
    cli_descuento DECIMAL(5,2) DEFAULT 0
);


-- Tabla DIRECCIONES 
CREATE TABLE direcciones (
    dir_id INT AUTO_INCREMENT PRIMARY KEY,
    dir_idcliente INT NOT NULL,
    dir_direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (dir_idcliente) REFERENCES cliente(cli_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- Tabla PEDIDO
CREATE TABLE pedido (
    ped_id INT AUTO_INCREMENT PRIMARY KEY,
    ped_idcliente INT NOT NULL,
    ped_direccion VARCHAR(255) NOT NULL,
    ped_fechapedido DATE NOT NULL,
    FOREIGN KEY (ped_idcliente) REFERENCES cliente(cli_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Tabla DETALLE_PEDIDO
CREATE TABLE detalle_pedido (
    detped_id INT AUTO_INCREMENT PRIMARY KEY,
    detped_idpedido INT NOT NULL,
    detped_idarticulo INT NOT NULL,
    detped_cantidad INT NOT NULL CHECK (detped_cantidad > 0),
    FOREIGN KEY (detped_idpedido) REFERENCES pedido(ped_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (detped_idarticulo) REFERENCES articulo(art_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Tabla: ARTICULO
CREATE TABLE articulo (
    art_id INT AUTO_INCREMENT PRIMARY KEY,
    art_descripcion VARCHAR(255) NOT NULL
);


-- Tabla: FABRICA
CREATE TABLE fabrica (
    fab_id INT AUTO_INCREMENT PRIMARY KEY,
    fab_nombre VARCHAR(100) NOT NULL,
    fab_telefono VARCHAR(30)
);


-- Tabla ARTICULO_FABRICA 
CREATE TABLE articulo_fabrica (
    artfab_idarticulo INT NOT NULL,
    artfab_idfabrica INT NOT NULL,
    artfab_existencias INT NOT NULL DEFAULT 0 CHECK (artfab_existencias >= 0),
    PRIMARY KEY (artfab_idarticulo, artfab_idfabrica),
    FOREIGN KEY (artfab_idarticulo) REFERENCES articulo(art_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (artfab_idfabrica) REFERENCES fabrica(fab_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
