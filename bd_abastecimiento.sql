CREATE DATABASE abastecimiento;
\c abastecimiento

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
  artfab_tipo_relacion VARCHAR(15) DEFAULT 'actual' CHECK (artfab_tipo_relacion IN ('actual', 'potencial')),
  PRIMARY KEY (artfab_idarticulo, artfab_idfabrica)
);
