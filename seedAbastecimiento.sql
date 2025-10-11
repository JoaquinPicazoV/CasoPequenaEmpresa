INSERT INTO articulo (art_nombre, art_descripcion, art_precio) VALUES
('Laptop HP ProBook 450 G9', 'Notebook empresarial 15.6", Intel Core i7, 16GB RAM, 512GB SSD', 850000),
('Monitor LG UltraWide 29"', 'Monitor IPS 29 pulgadas, resolución 2560x1080, HDMI/DisplayPort', 250000),
('Mouse Logitech M720 Triathlon', 'Mouse inalámbrico multi-dispositivo con Bluetooth y receptor USB', 40000),
('Teclado Mecánico Redragon K552 Kumara', 'Teclado mecánico con switches Outemu Blue retroiluminado', 35000),
('SSD Kingston NV2 1TB', 'Unidad de estado sólido NVMe PCIe 4.0, velocidad hasta 3500MB/s', 95000),
('Router TP-Link Archer AX73', 'Router Wi-Fi 6, banda dual, velocidad hasta 5400 Mbps', 130000),
('Impresora HP LaserJet Pro M404dn', 'Impresora láser monocromática con red y dúplex automático', 180000),
('Auriculares Sony WH-1000XM5', 'Auriculares inalámbricos con cancelación activa de ruido', 300000),
('Smartphone Samsung Galaxy S23', 'Teléfono móvil 6.1", 8GB RAM, 128GB almacenamiento', 799000),
('Tablet Apple iPad 10ª Gen', 'Pantalla 10.9", chip A14 Bionic, 64GB WiFi', 590000);

INSERT INTO fabrica (fab_nombre, fab_telefono, fab_region, fab_pais) VALUES
('Centro Logístico Santiago', '+56 2 1234567', 'Centro', 'Chile'),
('Bodega Antofagasta', '+56 55 2345678', 'Norte', 'Chile'),
('Depósito Temuco', '+56 45 3456789', 'Sur', 'Chile');

INSERT INTO articulo_fabrica VALUES
(1, 1, 50),   -- Laptop HP en Santiago
(2, 1, 40),   -- Monitor en Santiago
(3, 2, 60),   -- Mouse en Antofagasta
(4, 2, 30),   -- Teclado en Antofagasta
(5, 1, 100),  -- SSD en Santiago
(6, 3, 25),   -- Router en Temuco
(7, 1, 10),   -- Impresora en Santiago
(8, 3, 15),   -- Auriculares en Temuco
(9, 1, 20),   -- Smartphone en Santiago
(10, 2, 18);  -- iPad en Antofagasta
