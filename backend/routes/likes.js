const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los likes
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Likes';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los likes:', err);
            return res.status(500).send('Error al obtener los likes');
        }
        res.json(results);
    });
});

// Obtener todos los elementos de "likes" por id de usuario
router.get('/:Clientes_idUsuarios', (req, res) => {
    const { Clientes_idUsuarios } = req.params; // Extraemos el id del usuario desde los parámetros
    const query = 'SELECT * FROM Likes WHERE Clientes_idUsuarios = ?'; // Consultamos los "likes" de ese usuario
    db.query(query, [Clientes_idUsuarios], (err, results) => {
        if (err) {
            console.error('Error al obtener los likes:', err);
            return res.status(500).json({ error: 'Error al obtener los likes' }); // Manejo de errores
        }
        res.json(results); // Devolvemos todos los productos que el usuario tiene en "likes"
    });
});

// Crear un nuevo like
router.post('/', (req, res) => {
    const { Clientes_idUsuarios, Productos_idProductos } = req.body;
    const query = `
        INSERT INTO Likes (Clientes_idUsuarios, Productos_idProductos)
        VALUES (?, ?)`;
    db.query(query, [Clientes_idUsuarios, Productos_idProductos], (err, result) => {
        if (err) {
            console.error('Error al crear el like:', err);
            return res.status(500).send('Error al crear el like');
        }
        res.status(201).json({ message: 'Like creado correctamente', id: result.insertId });
    });
});

// Eliminar un like por usuario y producto
router.delete('/', (req, res) => {
    const { Clientes_idUsuarios, Productos_idProductos } = req.body;

    if (!Clientes_idUsuarios || !Productos_idProductos) {
        return res.status(400).send('Datos incompletos para eliminar el like');
    }

    const query = `
        DELETE FROM Likes 
        WHERE Clientes_idUsuarios = ? AND Productos_idProductos = ?`;

    db.query(query, [Clientes_idUsuarios, Productos_idProductos], (err, result) => {
        if (err) {
            console.error('Error al eliminar el like:', err);
            return res.status(500).send('Error al eliminar el like');
        }

        if (result.affectedRows === 0) {
            return res.status(404).send('Like no encontrado');
        }

        res.json({ message: 'Like eliminado correctamente' });
    });
});


module.exports = router;
