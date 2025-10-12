# 📦 Caso Pequeña Empresa

Este proyecto consiste modelo de datos para una pequeña empresa que gestiona principalmente información sobre **clientes**, **artículos**, **pedidos** y **fábricas**. El objetivo es estructurar y distribuir los datos de manera funcional y eficiente.

---

## Guía de ejecución
### REQUISITOS PREVIOS
- Tener instalado PostgreSQL y el/los software de gestión de base de datos a su elección (en nuestro caso pgAdmin y Antares).
- Tener al menos dos dispositivos para hostear las bases de datos.

### PASO 1
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
### PASO 2
Editar el archivo postgresql.conf en la ruta en la que esté guardada:
```bash
sudo nano /etc/postgresql/15/main/postgresql.conf
```
El "15"  dentro del archivo se cambia por la version actual que tengas de postgresql. También, la linea que tiene la variable listen_addresses debe estar así:
```bash
listen_addresses = '*'
```
Esto permitirá que el servidor escuche conexiones desde cualquier IP dentro de la red.

### PASO 3
Editar el archivo pg_hba.conf en la ruta en la que esté guardada:
```bash
sudo nano /etc/postgresql/15/main/pg_hba.conf
```
Agrega esta linea al final para permitir conexiones desde toda la red local (recuerda reemplazar con tu ip y máscara de red propia):
```bash
 host postgres       postgres
192.168.1.0/24    scram-sha-256
```

### PASO 4
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

### PASO 5
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
### PASO 6
Ahora se trabajará con ambos dispositivos, hay que crear las tablas con los archivos bd_abastecimiento.sql y bd_ventas.sql desde los respectivos software de gesitón de base de datos.

### PASO 7
Insertar datos en las tablas con los archivos seed_abastecimiento.sql y seed_ventas.sql disponibles en este repositorio.

### PASO 8
Conectar el otro dispositivo al dispositivo configurado inicialmente que se encuentra esuchando conexiones.

## PASOS PARA UTILIZACIÓN DE LAS BASES DE DATOS
### PASO 1
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
Ya te puedes conectar, ahora puedes utilizar las vistas y selecciones del archivo.
