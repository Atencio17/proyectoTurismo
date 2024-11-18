const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los productos
router.get('/', (req, res) => {
    const query = 'SELECT * FROM productos';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los productos:', err);
            return res.status(500).send('Error al obtener los productos');
        }
        res.json(results);
    });
});

// Obtener un producto por ID
router.get('/:idProducto', (req, res) => {
    const { idProducto } = req.params;
    const query = 'SELECT * FROM productos WHERE idProducto = ?';
    db.query(query, [idProducto], (err, results) => {
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
    const { nombre, detalle, imagen, categoria, tipo, precio } = req.body;
    const query = 'INSERT INTO productos (nombre, detalle, imagen, categoria, tipo, precio) VALUES (?, ?, ?, ?, ?, ?)';
    db.query(query, [nombre, detalle, imagen, categoria, tipo, precio], (err, result) => {
        if (err) {
            console.error('Error al crear el producto:', err);
            return res.status(500).send('Error al crear el producto');
        }
        res.status(201).json({
            idProducto: result.insertId,
            nombre,
            detalle,
            imagen,
            categoria,
            tipo,
            precio
        });
    });
});

// Actualizar un producto
router.put('/:idProducto', (req, res) => {
    const { idProducto } = req.params;
    const { nombre, detalle, imagen, categoria, tipo, precio } = req.body;
    const query = `
        UPDATE productos 
        SET nombre = ?, detalle = ?, imagen = ?, categoria = ?, tipo = ?, precio = ?
        WHERE idProducto = ?`;
    db.query(query, [nombre, detalle, imagen, categoria, tipo, precio, idProducto], (err, result) => {
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
router.delete('/:idProducto', (req, res) => {
    const { idProducto } = req.params;
    const query = 'DELETE FROM productos WHERE idProducto = ?';
    db.query(query, [idProducto], (err, result) => {
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

// Ruta para obtener productos por categoría
router.get('/categoria/:categoria', (req, res) => {
    const { categoria } = req.params;
    const query = 'SELECT * FROM productos WHERE categoria = ?';
    db.query(query, [categoria], (err, results) => {
        if (err) {
            console.error('Error al obtener los productos por categoría:', err);
            return res.status(500).send('Error al obtener los productos por categoría');
        }
        if (results.length === 0) {
            return res.status(404).send('No se encontraron productos en esta categoría');
        }
        res.json(results);
    });
});

module.exports = router;
