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
const clientesRoutes = require('./routes/clientes');
const productosRoutes = require('./routes/productos');
const comentariosRoutes = require('./routes/comentarios');
const likesRoutes = require('./routes/likes');
const carritoRoutes = require('./routes/carrito');
const comprasRoutes = require('./routes/compras');
const vendedorRoutes = require('./routes/vendedor');
const productosHasVendedorRoutes = require('./routes/productos_has_vendedor');

// Usar las rutas
app.use('/api/clientes', clientesRoutes);
app.use('/api/productos', productosRoutes);
app.use('/api/comentarios', comentariosRoutes);
app.use('/api/likes', likesRoutes);
app.use('/api/carrito', carritoRoutes);
app.use('/api/compras', comprasRoutes);
app.use('/api/vendedor', vendedorRoutes);
app.use('/api/productos-has-vendedor', productosHasVendedorRoutes);

// Exportar la app para usarla en pruebas
module.exports = app;

// Iniciar el servidor
if (process.env.NODE_ENV !== 'test') {
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));
}
