const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los registros de la tabla usuarios_has_servicios
router.get('/', (req, res) => {
    const query = 'SELECT * FROM usuarios_has_servicios';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los registros:', err);
            return res.status(500).send('Error al obtener los registros');
        }
        res.json(results);
    });
});

// Obtener un registro por idUsuario e idServicio
router.get('/:Usuarios_idUsuario/:Servicios_idServicio', (req, res) => {
    const { Usuarios_idUsuario, Servicios_idServicio } = req.params;
    const query = 'SELECT * FROM usuarios_has_servicios WHERE Usuarios_idUsuario = ? AND Servicios_idServicio = ?';
    db.query(query, [Usuarios_idUsuario, Servicios_idServicio], (err, results) => {
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
    const { Usuarios_idUsuario, Servicios_idServicio, fechaReserva, estado } = req.body;
    const query = 'INSERT INTO usuarios_has_servicios (Usuarios_idUsuario, Servicios_idServicio, fechaReserva, estado) VALUES (?, ?, ?, ?)';
    db.query(query, [Usuarios_idUsuario, Servicios_idServicio, fechaReserva, estado], (err, result) => {
        if (err) {
            console.error('Error al crear el registro:', err);
            return res.status(500).send('Error al crear el registro');
        }
        res.status(201).json({
            Usuarios_idUsuario,
            Servicios_idServicio,
            fechaReserva,
            estado
        });
    });
});

// Actualizar un registro
router.put('/:Usuarios_idUsuario/:Servicios_idServicio', (req, res) => {
    const { Usuarios_idUsuario, Servicios_idServicio } = req.params;
    const { fechaReserva, estado } = req.body;
    const query = `
        UPDATE usuarios_has_servicios 
        SET fechaReserva = ?, estado = ?
        WHERE Usuarios_idUsuario = ? AND Servicios_idServicio = ?`;
    db.query(query, [fechaReserva, estado, Usuarios_idUsuario, Servicios_idServicio], (err, result) => {
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
router.delete('/:Usuarios_idUsuario/:Servicios_idServicio', (req, res) => {
    const { Usuarios_idUsuario, Servicios_idServicio } = req.params;
    const query = 'DELETE FROM usuarios_has_servicios WHERE Usuarios_idUsuario = ? AND Servicios_idServicio = ?';
    db.query(query, [Usuarios_idUsuario, Servicios_idServicio], (err, result) => {
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
