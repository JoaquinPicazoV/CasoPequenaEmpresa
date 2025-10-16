# 📦 Caso Pequeña Empresa

Este proyecto consiste modelo de datos para una pequeña empresa que gestiona principalmente información sobre **clientes**, **artículos**, **pedidos** y **fábricas**. El objetivo es estructurar y distribuir los datos de manera funcional y eficiente.

---

## ⚙️ Guía de ejecución
### 📋 REQUISITOS PREVIOS
- Tener instalado PostgreSQL y el/los software de gestión de base de datos a su elección (en nuestro caso pgAdmin y Antares).
- Tener al menos dos dispositivos para hostear las bases de datos.

### ▶️ PASO 1
Para el paso actual y posteriores se trabajará con solo un dispotivo hasta que se diga lo contrario. Verificar que Postgresql esté instalado y corriendo con el comando:
```bash
sudo systemctl status postgresql
```
En caso de que no esté activo, utilizar:
```bash
sudo systemctl start postgresql
```
```bash
sudo systemctl enable postgresql
```
### ▶️ PASO 2
Editar el archivo postgresql.conf en la ruta en la que esté guardada:
```bash
sudo nano /etc/postgresql/15/main/postgresql.conf
```
El "15"  dentro del archivo se cambia por la version actual que tengas de postgresql. También, la linea que tiene la variable listen_addresses debe estar así:
```bash
listen_addresses = '*'
```
Esto permitirá que el servidor escuche conexiones desde cualquier IP dentro de la red.

### ▶️ PASO 3
Editar el archivo pg_hba.conf en la ruta en la que esté guardada:
```bash
sudo nano /etc/postgresql/15/main/pg_hba.conf
```
Agrega esta linea al final para permitir conexiones desde toda la red local (recuerda reemplazar con tu ip y máscara de red propia):
```bash
 host postgres       postgres
192.168.1.0/24    scram-sha-256
```

### ▶️ PASO 4
Crear usuario remoto (si no existe), primero entra a PostgreSQL con:
```bash
sudo -u postgres psql
```
Y usa:
```bash
CREATE ROLE ext_user WITH LOGIN PASSWORD 'postgres';
GRANT CONNECT ON DATABASE bd_abastecimiento TO ext_user;
GRANT USAGE ON SCHEMA public TO ext_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ext_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ext_user;
```

### ▶️ PASO 5
Reiniciar para aplicar cambios con el comando:
```bash
sudo systemctl restart postgresql
```
Y verificar que está escuchando conexiones en la red con:
```bash
ss -nltp | grep 5432
```
Debería aparecer algo como:
```bash
LISTEN 0 244 0.0.0.0:5432
```
### ▶️ PASO 6
Ahora se trabajará con ambos dispositivos, hay que crear las tablas con los archivos bd_abastecimiento.sql y bd_ventas.sql desde los respectivos software de gesitón de base de datos.

### ▶️ PASO 7
Insertar datos en las tablas con los archivos seed_abastecimiento.sql y seed_ventas.sql disponibles en este repositorio.

### ▶️ PASO 8
Conectar el otro dispositivo al dispositivo configurado inicialmente que se encuentra esuchando conexiones.

## 📡 PASOS PARA UTILIZACIÓN DE LAS BASES DE DATOS
### ▶️ PASO 1
Utilizar el archivo consultas.sql, pero se deben modificar algunos datos antes de usarlo para conectarse a la base de datos.
```bash
OPTIONS (
    host '192.168.1.82',  #Poner la ip del host de la bdd
    dbname 'postgres',  #Poner el nombre de tu bdd
    port '5432' #Poner el puerto que tienes corriendo la bdd
  );
```
```bash
OPTIONS (
    user 'ext_user', #Colocas tu usuario que hayas creado anteriormente con la consulta SQL
    password 'postgres' #Colocas la contraseña que hayas creado anteriormente para el usuario creado en la consulta SQL
  );
```
✅ Ya te puedes conectar, ahora puedes utilizar las vistas y selecciones del archivo.



# WINDOWS
Descargar e instalar POSTGRESQL 17, es importante que sea 17 porque un software que se usará posteriormente no tiene funcionamiento para POSTGRESQL 18.
```bash
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
```
Descargar e instalar MariaDB Connector/ODBC 64-bit x86.
```bash
https://mariadb.com/downloads/#connectors
```
```bash
Product: ODBC Connector
Version: Reomendad o actual
OS: MS Windows (64-bit x86)
```
Abrir ODBC Data Source / Administrador de origen de datos ODBC. IMPORTANTE: Debe ser el 64-bit x86, no el 32-bit. Si no lo encuentras con el buscador de Windows, es posible que se encuentre en:
```bash
C:\Windows\System32\odbcad32.exe
```

Configurar conexión con ODBC Data Source / Administrador de origen de datos ODBC. 
```bash
DSN de sistema > agregar > Elegir la opción de "MariaDB ODBC 3.2 Driver"
```

Completar campos para conectarse a la base de datos MariaDB, los campos y datos serán:
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

Descargar PostgreSQL 17 64-bit for Windows FDWs
```bash
https://www.postgresonline.com/journal/index.php?/archives/416-PostgreSQL-17-64-bit-for-Windows-FDWs.html
```

Descomprimir el archivo. Luego, entrar a carpeta descomprimida y:
1) Buscar el archivo odbc_fdw.dll y pegarlo en C:\Program Files\PostgreSQL\17\lib
2) Buscar odbc_fdw.control y pegarlo en C:\Program Files\PostgreSQL\17\share\extension
3) Buscar odbc_fdw--0.5.2 y pegarlo en C:\Program Files\PostgreSQL\17\share\extension

Entrar al gestor de base de datos pgAdmin4 para crear la base de datos y sus tablas.
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
Insertar datos de prueba (ficticios) en base de datos actual.
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




