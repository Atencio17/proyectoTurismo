require('dotenv').config();
const mysql = require('mysql');

// Usar createPool en lugar de createConnection para manejar múltiples conexiones
const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionLimit: 10, // Número de conexiones simultáneas
});

// Verificar la conexión y mostrar mensaje solo si no estamos en el entorno de pruebas
db.getConnection((err, connection) => {
    if (err) {
        console.error('Error al conectar con la base de datos:', err);
        return;
    }
    if (process.env.NODE_ENV !== 'test') {
        console.log('Conexión exitosa a la base de datos');
    }
    // Liberar la conexión una vez realizada la verificación
    connection.release();
});

module.exports = db;
