const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los comentarios
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Comentarios';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los comentarios:', err);
            return res.status(500).send('Error al obtener los comentarios');
        }
        res.json(results);
    });
});

// Obtener un comentario por ID
router.get('/:idComentarios', (req, res) => {
    const { idComentarios } = req.params;
    const query = 'SELECT * FROM Comentarios WHERE idComentarios = ?';
    db.query(query, [idComentarios], (err, results) => {
        if (err) {
            console.error('Error al obtener el comentario:', err);
            return res.status(500).send('Error al obtener el comentario');
        }
        if (results.length === 0) {
            return res.status(404).send('Comentario no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo comentario
router.post('/', (req, res) => {
    const { reseña, Productos_idProductos, Clientes_idUsuarios, Clientes_tipodocumento } = req.body;
    const query = `
        INSERT INTO Comentarios (reseña, Productos_idProductos, Clientes_idUsuarios, Clientes_tipodocumento)
        VALUES (?, ?, ?, ?)`;
    db.query(query, [reseña, Productos_idProductos, Clientes_idUsuarios, Clientes_tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al crear el comentario:', err);
            return res.status(500).send('Error al crear el comentario');
        }
        res.status(201).json({ message: 'Comentario creado correctamente', id: result.insertId });
    });
});

// Actualizar un comentario
router.put('/:idComentarios', (req, res) => {
    const { idComentarios } = req.params;
    const { reseña } = req.body;
    const query = `
        UPDATE Comentarios 
        SET reseña = ?
        WHERE idComentarios = ?`;
    db.query(query, [reseña, idComentarios], (err, result) => {
        if (err) {
            console.error('Error al actualizar el comentario:', err);
            return res.status(500).send('Error al actualizar el comentario');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Comentario no encontrado');
        }
        res.json({ message: 'Comentario actualizado correctamente' });
    });
});

// Eliminar un comentario
router.delete('/:idComentarios', (req, res) => {
    const { idComentarios } = req.params;
    const query = 'DELETE FROM Comentarios WHERE idComentarios = ?';
    db.query(query, [idComentarios], (err, result) => {
        if (err) {
            console.error('Error al eliminar el comentario:', err);
            return res.status(500).send('Error al eliminar el comentario');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Comentario no encontrado');
        }
        res.json({ message: 'Comentario eliminado correctamente' });
    });
});

module.exports = router;
