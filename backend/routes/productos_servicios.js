const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todas las relaciones
router.get('/', (req, res) => {
    const query = `
        SELECT p.nombre AS producto, s.nombre AS servicio
        FROM productos_has_servicios ps
        JOIN productos p ON ps.Productos_idProducto = p.idProducto
        JOIN servicios s ON ps.Servicios_idServicio = s.idServicio`;
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener las relaciones:', err);
            return res.status(500).send('Error al obtener las relaciones');
        }
        res.json(results);
    });
});

// Obtener relaciones por ID de producto
router.get('/producto/:idProducto', (req, res) => {
    const { idProducto } = req.params;
    const query = `
        SELECT s.idServicio, s.nombre AS servicio
        FROM productos_has_servicios ps
        JOIN servicios s ON ps.Servicios_idServicio = s.idServicio
        WHERE ps.Productos_idProducto = ?`;
    db.query(query, [idProducto], (err, results) => {
        if (err) {
            console.error('Error al obtener los servicios del producto:', err);
            return res.status(500).send('Error al obtener los servicios del producto');
        }
        res.json(results);
    });
});

// Crear una relación entre producto y servicio
router.post('/', (req, res) => {
    const { Productos_idProducto, Servicios_idServicio } = req.body;
    const query = 'INSERT INTO productos_has_servicios (Productos_idProducto, Servicios_idServicio) VALUES (?, ?)';
    db.query(query, [Productos_idProducto, Servicios_idServicio], (err, result) => {
        if (err) {
            console.error('Error al crear la relación:', err);
            return res.status(500).send('Error al crear la relación');
        }
        res.status(201).json({ Productos_idProducto, Servicios_idServicio });
    });
});

// Eliminar una relación entre producto y servicio
router.delete('/', (req, res) => {
    const { Productos_idProducto, Servicios_idServicio } = req.body;
    const query = 'DELETE FROM productos_has_servicios WHERE Productos_idProducto = ? AND Servicios_idServicio = ?';
    db.query(query, [Productos_idProducto, Servicios_idServicio], (err, result) => {
        if (err) {
            console.error('Error al eliminar la relación:', err);
            return res.status(500).send('Error al eliminar la relación');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Relación no encontrada');
        }
        res.send('Relación eliminada correctamente');
    });
});

module.exports = router;
