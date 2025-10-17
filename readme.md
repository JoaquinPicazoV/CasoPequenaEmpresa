# 📦 Caso Pequeña Empresa

Este proyecto consiste modelo de datos para una pequeña empresa que gestiona principalmente información sobre **clientes**, **artículos**, **pedidos** y **fábricas**. El objetivo es estructurar y distribuir los datos de manera funcional y eficiente.

---

## ⚙️ Guía de ejecución
### 📋 REQUISITOS PREVIOS
- De preferencia tener un Windos con instalado PostgreSQL y pgAdmin4 instalado, y en una Raspberri Pi distro linux tener instalado MariaDB y Antares. De todas formas se explica el paso a paso la descarga e instalación de estos. Pero es netamente para acelerear el proceso.
- Tener dos dispositivos para hostear las bases de datos.

# RASPBERRY PI
###  ▶️ PASO 1: Actualizar e instalar la raspberri
```bash
sudo apt update
sudo apt upgrade -y
```
```bash
sudo apt upgrade -y
```

###  ▶️ PASO 2: Instalar lo necesario para usar MariaDB
```bash
sudo apt install mariadb-server
sudo apt install mariadb-client
```

###  ▶️  PASO 3: Permitir conexiones al puerto donde correrá el servidor con MariaDB y la DB trabajando con el firewall
```bash
sudo ufw allow 3306/tcp
sudo ufw enable
sudo ufw status
```
Opción 2: realizarlo con iptables (pero recomendamos usar ufw)

###  ▶️  PASO 4: Permitir conexiones remotas al dispositivo para MariaDB
```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
bind-address = 0.0.0.0
sudo systemctl restart mariadb
```

### ▶️  PASO 5: Descargar Antares SQL
```bash
https://antares-sql.app/downloads
```
Nota: Elegir ARMv8	AppImage	stable

### ▶️ PASO 6: Ejecutar el .AppImage. Ir a la ubicación de la descarga (en nuestro caso en "Descargas") y ejecutar:
```bash
chmod +x Antares-SQL-1.27.0-arm64.AppImage
./Antares-SQL-1.27.0-arm64.AppImage
```
Nota: Ustedes usan el nombre del archivo que tengan, para nuestro caso fue este. El nombre y versión pueden cambiar con el tiempo.

### ▶️  PASO 7:  Para ejecutar y abrir Antares de ahora en adelante se usará el siguiente comando en la ruta que esté ubicada el archivo 
```bash
./Antares-SQL-1.27.0-arm64.AppImage
```

### ▶️  PASO 7: Crear un usuario para conectarse al puerto y base de datos para administrarla
```bash
sudo mysql
CREATE USER 'fdw_user'@'%' IDENTIFIED BY 'tu_contraseña_segura';
GRANT ALL PRIVILEGES ON ventas.* TO 'fdw_user'@'%';
FLUSH PRIVILEGES;
```

### ▶️ PASO 8: Entrar a Antares y realizar la conexión a la base de datos indicando como se llamará el servidor, el host (local), motor de la base de datos, puerto y credenciales de acceso creada anteriormente

### ▶️ PASO 9: Crear la base de datos y tablas
```bash
CREATE DATABASE IF NOT EXISTS ventas;

USE ventas;

CREATE TABLE cliente (
  -- Reemplaza SERIAL PRIMARY KEY con INT AUTO_INCREMENT PRIMARY KEY
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
```

### ▶️  PASO 10: Insertar datos de prueba (ficticios) a la base de datos
```bash
INSERT INTO cliente (cli_nombre, cli_limitecredito) VALUES
('Cliente A', 2000000),
('Cliente B', 1500000);

INSERT INTO direcciones (dir_id, dir_idcliente, dir_calle, dir_ciudad, dir_region, dir_pais) VALUES
(1, 1, 'Av. Los Andes 123', 'Puerto Montt', 'Sur', 'Chile'),
(2, 1, 'Calle del Mar 45', 'Valdivia', 'Sur', 'Chile'),
(1, 2, 'Av. Japón 900', 'Santiago', 'Centro', 'Chile');

INSERT INTO pedido (ped_idcliente, ped_direccion) VALUES
(1, 1), -- Cliente 1, Dirección ID 1 (Chile, Puerto Montt)
(2, 1); -- Cliente 2, Dirección ID 1 (Chile, Santiago)

INSERT INTO detalle_pedido (detped_idpedido, detped_idarticulo, detped_cantidad, detped_precio)
VALUES
(1, 101, 10, 3500), -- Pedido 1, Artículo 101
(2, 102, 5, 2000);  -- Pedido 2, Artículo 102
```
✅ Ahora la base de datos funciona de forma local y permite recibir conexiones al puerto especificado, pudiendo conectar la otra parte de la base de datos fragmentada en otro dispositivo host para unificarlas.


# WINDOWS
### ▶️  PASO 1: Descargar e instalar POSTGRESQL 17, es importante que sea 17 porque un software que se usará posteriormente no tiene funcionamiento para POSTGRESQL 18.
```bash
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
```
### ▶️  PASO 2: Descargar e instalar MariaDB Connector/ODBC 64-bit x86.
```bash
https://mariadb.com/downloads/#connectors
```
```bash
Product: ODBC Connector
Version: Reomendad o actual
OS: MS Windows (64-bit x86)
```
### ▶️  PASO 3: Abrir ODBC Data Source / Administrador de origen de datos ODBC. IMPORTANTE: Debe ser el 64-bit x86, no el 32-bit. Si no lo encuentras con el buscador de Windows, es posible que se encuentre en:
```bash
C:\Windows\System32\odbcad32.exe
```

### ▶️  PASO 4: Configurar conexión con ODBC Data Source / Administrador de origen de datos ODBC. 
```bash
DSN de sistema > agregar > Elegir la opción de "MariaDB ODBC 3.2 Driver"
```

### ▶️  PASO 5: Completar campos para conectarse a la base de datos MariaDB, los campos y datos serán:
```bash
Name: MariaDB_RPi
Description: Conexión a MariaDB en Raspberry Pi
Server Name: <ip_raspberry_pi>
Port: <puerto_bdd_raspberry_pi>
User name: usuario_bdd_habilitado_para_conexión
Password: contraseña_usuario
Database: ventas (o el que corresponda según nombre DB en Raspberry Pi)

NOTA: El resto dejarlo por defecto y > next > next > next > next > finish
```

### ▶️  PASO 6: Descargar PostgreSQL 17 64-bit for Windows FDWs
```bash
https://www.postgresonline.com/journal/index.php?/archives/416-PostgreSQL-17-64-bit-for-Windows-FDWs.html
```

### ▶️  PASO 7: Descomprimir el archivo. Luego, entrar a carpeta descomprimida y:
1) Buscar el archivo odbc_fdw.dll y pegarlo en C:\Program Files\PostgreSQL\17\lib
2) Buscar odbc_fdw.control y pegarlo en C:\Program Files\PostgreSQL\17\share\extension
3) Buscar odbc_fdw--0.5.2 y pegarlo en C:\Program Files\PostgreSQL\17\share\extension

### ▶️  PASO 8: Entrar al gestor de base de datos pgAdmin4 para crear la base de datos y sus tablas.
```bash
CREATE DATABASE abastecimiento;

CREATE TABLE articulo (
    art_id SERIAL PRIMARY KEY,
    art_nombre VARCHAR(100) NOT NULL,
    art_descripcion VARCHAR(255),
    art_precio NUMERIC(12,2) NOT NULL CHECK (art_precio > 0)
);

CREATE TABLE fabrica (
    fab_id SERIAL PRIMARY KEY,
    fab_nombre VARCHAR(100) NOT NULL,
    fab_telefono VARCHAR(20),
    fab_region VARCHAR(50),
    fab_pais VARCHAR(50)
);

CREATE TABLE articulo_fabrica (
    artfab_idarticulo INT NOT NULL REFERENCES articulo(art_id),
    artfab_idfabrica  INT NOT NULL REFERENCES fabrica(fab_id),
    artfab_existencias INT NOT NULL DEFAULT 0 CHECK (artfab_existencias >= 0),
    artfab_tipo_relacion VARCHAR(15) DEFAULT 'actual' CHECK (artfab_tipo_relacion IN ('actual', 'alternativa')),
    PRIMARY KEY (artfab_idarticulo, artfab_idfabrica)
);
```
### ▶️  PASO 9: Insertar datos de prueba (ficticios) en base de datos actual.
```bash
DO $$
DECLARE
    -- Arrays para almacenar los IDs generados
    ids_articulos INT[] := ARRAY[]::INT[];
    ids_fabricas INT[] := ARRAY[]::INT[];
    id_actual INT;
BEGIN
    
    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Laptop HP ProBook 450 G9', 'Notebook empresarial 15.6", Intel Core i7, 16GB RAM, 512GB SSD', 850000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Monitor LG UltraWide 29"', 'Monitor IPS 29 pulgadas, resolución 2560x1080, HDMI/DisplayPort', 250000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 
    
    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Mouse Logitech M720 Triathlon', 'Mouse inalámbrico multi-dispositivo con Bluetooth y receptor USB', 40000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 
    
    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Teclado Mecánico Redragon K552 Kumara', 'Teclado mecánico con switches Outemu Blue retroiluminado', 35000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('SSD Kingston NV2 1TB', 'Unidad de estado sólido NVMe PCIe 4.0, velocidad hasta 3500MB/s', 95000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Router TP-Link Archer AX73', 'Router Wi-Fi 6, banda dual, velocidad hasta 5400 Mbps', 130000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Impresora HP LaserJet Pro M404dn', 'Impresora láser monocromática con red y dúplex automático', 180000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Auriculares Sony WH-1000XM5', 'Auriculares inalámbricos con cancelación activa de ruido', 300000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Smartphone Samsung Galaxy S23', 'Teléfono móvil 6.1", 8GB RAM, 128GB almacenamiento', 799000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
    ('Tablet Apple iPad 10ª Gen', 'Pantalla 10.9", chip A14 Bionic, 64GB WiFi', 590000) RETURNING art_id INTO id_actual;
    ids_articulos := array_append(ids_articulos, id_actual); 

    INSERT INTO fabrica (fab_nombre, fab_telefono, fab_region, fab_pais) VALUES
    ('Centro Logístico Santiago', '+56 2 1234567', 'Centro', 'Chile') RETURNING fab_id INTO id_actual;
    ids_fabricas := array_append(ids_fabricas, id_actual); 
    
    INSERT INTO fabrica (fab_nombre, fab_telefono, fab_region, fab_pais) VALUES
    ('Bodega Antofagasta', '+56 55 2345678', 'Norte', 'Chile') RETURNING fab_id INTO id_actual;
    ids_fabricas := array_append(ids_fabricas, id_actual); 

    INSERT INTO fabrica (fab_nombre, fab_telefono, fab_region, fab_pais) VALUES
    ('Depósito Temuco', '+56 45 3456789', 'Sur', 'Chile') RETURNING fab_id INTO id_actual;
    ids_fabricas := array_append(ids_fabricas, id_actual);

    INSERT INTO fabrica (fab_nombre, fab_telefono, fab_region, fab_pais) VALUES
    ('Proveedor Alternativo Valdivia', '+56 63 9876543', 'Sur', 'Chile') RETURNING fab_id INTO id_actual;
    ids_fabricas := array_append(ids_fabricas, id_actual); 

    INSERT INTO articulo_fabrica (artfab_idarticulo, artfab_idfabrica, artfab_existencias, artfab_tipo_relacion) VALUES
    (ids_articulos[1], ids_fabricas[1], 50, 'actual'),  
    (ids_articulos[2], ids_fabricas[1], 40, 'actual'),  
    (ids_articulos[3], ids_fabricas[2], 60, 'actual'),  
    (ids_articulos[4], ids_fabricas[2], 30, 'actual'),   
    (ids_articulos[5], ids_fabricas[1], 100, 'actual'), 
    (ids_articulos[6], ids_fabricas[3], 25, 'actual'),   
    (ids_articulos[7], ids_fabricas[1], 10, 'actual'),  
    (ids_articulos[8], ids_fabricas[3], 15, 'actual'), 
    (ids_articulos[9], ids_fabricas[1], 20, 'actual'),  
    (ids_articulos[10], ids_fabricas[2], 18, 'actual');  

    INSERT INTO articulo_fabrica (artfab_idarticulo, artfab_idfabrica, artfab_existencias, artfab_tipo_relacion) VALUES
    (ids_articulos[1], ids_fabricas[4], 500, 'alternativa'), 
    (ids_articulos[3], ids_fabricas[4], 46, 'alternativa'), 
    (ids_articulos[8], ids_fabricas[4], 243, 'alternativa'); 

END $$;
```

### ▶️  PASO 10: Conectarse a la base de datos remota usando las credenciales guardadas en el DSN para unificar las segmentaciones y realizar consultas normales.
```bash
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
```
✅ Ya están conectadas ambas bases de datos, desde este dispositivo actual (Windows) se pueden enviar querys como si las tablas de la base de datos de la Raspberry Pi estuviera localmente en esta máquina. Unificación completa de la base de dato distribuida. El usuario no sabrá como está fragmentada ni su ubicación o la cantidad de dispositivos, solo usará el servicio.



