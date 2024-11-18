const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los servicios
router.get('/', (req, res) => {
    const query = 'SELECT * FROM servicios';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los servicios:', err);
            return res.status(500).send('Error al obtener los servicios');
        }
        res.json(results);
    });
});

// Obtener un servicio por ID
router.get('/:idServicio', (req, res) => {
    const { idServicio } = req.params;
    const query = 'SELECT * FROM servicios WHERE idServicio = ?';
    db.query(query, [idServicio], (err, results) => {
        if (err) {
            console.error('Error al obtener el servicio:', err);
            return res.status(500).send('Error al obtener el servicio');
        }
        if (results.length === 0) {
            return res.status(404).send('Servicio no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo servicio
router.post('/', (req, res) => {
    const { nombre, descripcion, precio, duracion, tipo, categoria, imagen } = req.body;
    const query = 'INSERT INTO servicios (nombre, descripcion, precio, duracion, tipo, categoria, imagen) VALUES (?, ?, ?, ?, ?, ?, ?)';
    db.query(query, [nombre, descripcion, precio, duracion, tipo, categoria, imagen], (err, result) => {
        if (err) {
            console.error('Error al crear el servicio:', err);
            return res.status(500).send('Error al crear el servicio');
        }
        res.status(201).json({
            idServicio: result.insertId,
            nombre,
            descripcion,
            precio,
            duracion,
            tipo,
            categoria,
            imagen
        });
    });
});

// Actualizar un servicio
router.put('/:idServicio', (req, res) => {
    const { idServicio } = req.params;
    const { nombre, descripcion, precio, duracion, tipo, categoria, imagen } = req.body;
    const query = `
        UPDATE servicios 
        SET nombre = ?, descripcion = ?, precio = ?, duracion = ?, tipo = ?, categoria = ?, imagen = ?
        WHERE idServicio = ?`;
    db.query(query, [nombre, descripcion, precio, duracion, tipo, categoria, imagen, idServicio], (err, result) => {
        if (err) {
            console.error('Error al actualizar el servicio:', err);
            return res.status(500).send('Error al actualizar el servicio');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Servicio no encontrado');
        }
        res.json({ message: 'Servicio actualizado correctamente' });
    });
});

// Eliminar un servicio
router.delete('/:idServicio', (req, res) => {
    const { idServicio } = req.params;
    const query = 'DELETE FROM servicios WHERE idServicio = ?';
    db.query(query, [idServicio], (err, result) => {
        if (err) {
            console.error('Error al eliminar el servicio:', err);
            return res.status(500).send('Error al eliminar el servicio');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Servicio no encontrado');
        }
        res.json({ message: 'Servicio eliminado correctamente' });
    });
});

module.exports = router;
