const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todas las compras
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Compras';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener las compras:', err);
            return res.status(500).send('Error al obtener las compras');
        }
        res.json(results);
    });
});

// Obtener una compra por ID
router.get('/:idCompras', (req, res) => {
    const { idCompras } = req.params;
    const query = 'SELECT * FROM Compras WHERE idCompras = ?';
    db.query(query, [idCompras], (err, results) => {
        if (err) {
            console.error('Error al obtener la compra:', err);
            return res.status(500).send('Error al obtener la compra');
        }
        if (results.length === 0) {
            return res.status(404).send('Compra no encontrada');
        }
        res.json(results[0]);
    });
});

// Crear una nueva compra
router.post('/', (req, res) => {
    const { cantidad, Clientes_idUsuarios, Productos_idProductos } = req.body;
    const query = `
        INSERT INTO Compras (cantidad, Clientes_idUsuarios, Productos_idProductos)
        VALUES (?, ?, ?)`;
    db.query(query, [cantidad, Clientes_idUsuarios, Productos_idProductos], (err, result) => {
        if (err) {
            console.error('Error al crear la compra:', err);
            return res.status(500).send('Error al crear la compra');
        }
        res.status(201).json({ message: 'Compra creada correctamente', id: result.insertId });
    });
});

// Actualizar una compra
router.put('/:idCompras', (req, res) => {
    const { idCompras } = req.params;
    const { cantidad } = req.body;
    const query = `
        UPDATE Compras
        SET cantidad = ?
        WHERE idCompras = ?`;
    db.query(query, [cantidad, idCompras], (err, result) => {
        if (err) {
            console.error('Error al actualizar la compra:', err);
            return res.status(500).send('Error al actualizar la compra');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Compra no encontrada');
        }
        res.json({ message: 'Compra actualizada correctamente' });
    });
});

// Eliminar una compra
router.delete('/:idCompras', (req, res) => {
    const { idCompras } = req.params;
    const query = 'DELETE FROM Compras WHERE idCompras = ?';
    db.query(query, [idCompras], (err, result) => {
        if (err) {
            console.error('Error al eliminar la compra:', err);
            return res.status(500).send('Error al eliminar la compra');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Compra no encontrada');
        }
        res.json({ message: 'Compra eliminada correctamente' });
    });
});

module.exports = router;
