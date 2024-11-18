require('dotenv').config(); // Carga las variables de entorno
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Importar conexión a la base de datos
const db = require('./db');

// Rutas
const productosRoutes = require('./routes/productos');
const productosServiciosRoutes = require('./routes/productos_servicios');
const serviciosRoutes = require('./routes/servicios');
const usuariosRoutes = require('./routes/usuarios');
const usuariosHasProductosRoutes = require('./routes/usuariosHasProductos');
const usuariosHasServiciosRoutes = require('./routes/usuariosHasServicios');
app.use('/api/productos', productosRoutes);
app.use('/api/productos-servicios', productosServiciosRoutes);
app.use('/api/servicios', serviciosRoutes);
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/usuarios-has-productos', usuariosHasProductosRoutes);
app.use('/api/usuarios-has-servicios', usuariosHasServiciosRoutes);

// Inicio del servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
