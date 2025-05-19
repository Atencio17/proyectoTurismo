const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los productos
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Productos';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los productos:', err);
            return res.status(500).send('Error al obtener los productos');
        }
        res.json(results);
    });
});

// Obtener un producto por ID
router.get('/:idProductos', (req, res) => {
    const { idProductos } = req.params;
    const query = 'SELECT * FROM Productos WHERE idProductos = ?';
    db.query(query, [idProductos], (err, results) => {
        if (err) {
            console.error('Error al obtener el producto:', err);
            return res.status(500).send('Error al obtener el producto');
        }
        if (results.length === 0) {
            return res.status(404).send('Producto no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo producto
router.post('/', (req, res) => {
    const { nombre, detalle, imagen, stock, categoria, precio } = req.body;
    const query = `
        INSERT INTO Productos (nombre, detalle, imagen, stock, categoria, precio)
        VALUES (?, ?, ?, ?, ?, ?)`;
    db.query(query, [nombre, detalle, imagen, stock, categoria, precio], (err, result) => {
        if (err) {
            console.error('Error al crear el producto:', err);
            return res.status(500).send('Error al crear el producto');
        }
        res.status(201).json({ message: 'Producto creado correctamente', id: result.insertId });
    });
});

// Actualizar un producto
router.put('/:idProductos', (req, res) => {
    const { idProductos } = req.params;
    const { nombre, detalle, imagen, stock, categoria, precio } = req.body;
    const query = `
        UPDATE Productos
        SET nombre = ?, detalle = ?, imagen = ?, stock = ?, categoria = ?, precio = ?
        WHERE idProductos = ?`;
    db.query(query, [nombre, detalle, imagen, stock, categoria, precio, idProductos], (err, result) => {
        if (err) {
            console.error('Error al actualizar el producto:', err);
            return res.status(500).send('Error al actualizar el producto');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Producto no encontrado');
        }
        res.json({ message: 'Producto actualizado correctamente' });
    });
});

// Eliminar un producto
router.delete('/:idProductos', (req, res) => {
    const { idProductos } = req.params;
    const query = 'DELETE FROM Productos WHERE idProductos = ?';
    db.query(query, [idProductos], (err, result) => {
        if (err) {
            console.error('Error al eliminar el producto:', err);
            return res.status(500).send('Error al eliminar el producto');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Producto no encontrado');
        }
        res.json({ message: 'Producto eliminado correctamente' });
    });
});

module.exports = router;
