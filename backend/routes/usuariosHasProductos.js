const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los registros de la tabla usuarios_has_productos
router.get('/', (req, res) => {
    const query = 'SELECT * FROM usuarios_has_productos';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los registros:', err);
            return res.status(500).send('Error al obtener los registros');
        }
        res.json(results);
    });
});

// Obtener un registro por idUsuario e idProducto
router.get('/:Usuarios_idUsuario/:Productos_idProducto', (req, res) => {
    const { Usuarios_idUsuario, Productos_idProducto } = req.params;
    const query = 'SELECT * FROM usuarios_has_productos WHERE Usuarios_idUsuario = ? AND Productos_idProducto = ?';
    db.query(query, [Usuarios_idUsuario, Productos_idProducto], (err, results) => {
        if (err) {
            console.error('Error al obtener el registro:', err);
            return res.status(500).send('Error al obtener el registro');
        }
        if (results.length === 0) {
            return res.status(404).send('Registro no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo registro
router.post('/', (req, res) => {
    const { Usuarios_idUsuario, Productos_idProducto, likes, carrito, miLista } = req.body;
    const query = 'INSERT INTO usuarios_has_productos (Usuarios_idUsuario, Productos_idProducto, likes, carrito, miLista) VALUES (?, ?, ?, ?, ?)';
    db.query(query, [Usuarios_idUsuario, Productos_idProducto, likes, carrito, miLista], (err, result) => {
        if (err) {
            console.error('Error al crear el registro:', err);
            return res.status(500).send('Error al crear el registro');
        }
        res.status(201).json({
            idUsuario: Usuarios_idUsuario,
            idProducto: Productos_idProducto,
            likes,
            carrito,
            miLista
        });
    });
});

// Actualizar un registro
router.put('/:Usuarios_idUsuario/:Productos_idProducto', (req, res) => {
    const { Usuarios_idUsuario, Productos_idProducto } = req.params;
    const { likes, carrito, miLista } = req.body;
    const query = `
        UPDATE usuarios_has_productos 
        SET likes = ?, carrito = ?, miLista = ?
        WHERE Usuarios_idUsuario = ? AND Productos_idProducto = ?`;
    db.query(query, [likes, carrito, miLista, Usuarios_idUsuario, Productos_idProducto], (err, result) => {
        if (err) {
            console.error('Error al actualizar el registro:', err);
            return res.status(500).send('Error al actualizar el registro');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Registro no encontrado');
        }
        res.json({ message: 'Registro actualizado correctamente' });
    });
});

// Eliminar un registro
router.delete('/:Usuarios_idUsuario/:Productos_idProducto', (req, res) => {
    const { Usuarios_idUsuario, Productos_idProducto } = req.params;
    const query = 'DELETE FROM usuarios_has_productos WHERE Usuarios_idUsuario = ? AND Productos_idProducto = ?';
    db.query(query, [Usuarios_idUsuario, Productos_idProducto], (err, result) => {
        if (err) {
            console.error('Error al eliminar el registro:', err);
            return res.status(500).send('Error al eliminar el registro');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Registro no encontrado');
        }
        res.json({ message: 'Registro eliminado correctamente' });
    });
});

module.exports = router;
