# 📦 Caso Pequeña Empresa

Este proyecto consiste modelo de datos para una pequeña empresa que gestiona principalmente información sobre **clientes**, **artículos**, **pedidos** y **fábricas**. El objetivo es estructurar y distribuir los datos de manera funcional y eficiente.

---

## Guía de ejecución
### REQUISITOS PREVIOS
- Tener instalado PostgreSQL y el/los software de gestión de base de datos a su elección (en nuestro caso pgAdmin y Antares).
- Tener al menos dos dispositivos para hostear las bases de datos.

### PASO 1
Verificar que Postgresql esté instalado y corriendo con el comando:
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
Agrega esta linea al final para permitir conexiones desde toda la red local:
```bash
 host postgres       postgres
192.168.1.0/24    scram-sha-256
```
### PASO 
Crear las tablas con los archivos bd_abastecimiento.sql y bd_ventas.sql desde los respectivos software de gesitón de base de datos.

### PASO 
Insertar datos en las tablas con los archivos seed_abastecimiento.sql y seed_ventas.sql disponibles en este repositorio.

### PASO 
