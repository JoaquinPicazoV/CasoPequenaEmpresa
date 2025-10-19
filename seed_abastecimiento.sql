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