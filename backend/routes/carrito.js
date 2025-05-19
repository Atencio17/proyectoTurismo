const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los elementos del carrito por id de usuario
router.get('/:Clientes_idUsuarios', (req, res) => {
    const { Clientes_idUsuarios } = req.params;
    const query = 'SELECT * FROM carrito WHERE Clientes_idUsuarios = ?';
    db.query(query, [Clientes_idUsuarios], (err, results) => {
        if (err) {
            console.error('Error al obtener el carrito:', err);
            return res.status(500).json({ error: 'Error al obtener el carrito' });
        }
        res.json(results);
    });
});

// Crear un nuevo elemento en el carrito
router.post('/', (req, res) => {
    const { cantidad, Clientes_idUsuarios, Productos_idProductos } = req.body;
    const query = `
        INSERT INTO Carrito (cantidad, Clientes_idUsuarios, Productos_idProductos)
        VALUES (?, ?, ?)`;
    db.query(query, [cantidad, Clientes_idUsuarios, Productos_idProductos], (err, result) => {
        if (err) {
            console.error('Error al agregar al carrito:', err);
            return res.status(500).send('Error al agregar al carrito');
        }
        res.status(201).json({ message: 'Elemento agregado al carrito correctamente', id: result.insertId });
    });
});

// Actualizar la cantidad de un elemento en el carrito
router.put('/:idCarrito', (req, res) => {
    const { idCarrito } = req.params;
    const { cantidad } = req.body;

    if (!cantidad) {
        return res.status(400).json({ error: 'La cantidad es obligatoria' });
    }

    const query = `
        UPDATE carrito
        SET cantidad = ?
        WHERE idCarrito = ?`;
    db.query(query, [cantidad, idCarrito], (err, result) => {
        if (err) {
            console.error('Error al actualizar el carrito:', err);
            return res.status(500).json({ error: 'Error al actualizar el carrito' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Elemento no encontrado en el carrito' });
        }
        res.json({ message: 'Carrito actualizado correctamente' });
    });
});

// Eliminar un elemento del carrito por producto id
router.delete('/:Productos_idProductos', (req, res) => {
    const { Productos_idProductos } = req.params;

    const query = 'DELETE FROM carrito WHERE Productos_idProductos = ?';
    db.query(query, [Productos_idProductos], (err, result) => {
        if (err) {
            console.error('Error al eliminar del carrito:', err);
            return res.status(500).json({ error: 'Error al eliminar del carrito' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Elemento no encontrado en el carrito' });
        }
        res.json({ message: 'Elemento eliminado del carrito correctamente' });
    });
});

module.exports = router;
