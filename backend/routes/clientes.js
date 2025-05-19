const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los clientes
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Clientes';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los clientes:', err);
            return res.status(500).send('Error al obtener los clientes');
        }
        res.json(results);
    });
});

// Obtener un cliente por ID y tipo de documento
router.get('/:idUsuarios/:tipodocumento', (req, res) => {
    const { idUsuarios, tipodocumento } = req.params;
    const query = 'SELECT * FROM Clientes WHERE idUsuarios = ? AND tipodocumento = ?';
    db.query(query, [idUsuarios, tipodocumento], (err, results) => {
        if (err) {
            console.error('Error al obtener el cliente:', err);
            return res.status(500).send('Error al obtener el cliente');
        }
        if (results.length === 0) {
            return res.status(404).send('Cliente no encontrado');
        }
        res.json(results[0]);
    });
});

// Obtener un cliente por ID
router.get('/:idUsuarios', (req, res) => {
    const { idUsuarios } = req.params;
    const query = 'SELECT * FROM Clientes WHERE idUsuarios = ?';
    db.query(query, [idUsuarios], (err, results) => {
        if (err) {
            console.error('Error al obtener el cliente:', err);
            return res.status(500).send('Error al obtener el cliente');
        }
        if (results.length === 0) {
            return res.status(404).send('Cliente no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo cliente
router.post('/', (req, res) => {
    const { idUsuarios, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña } = req.body;
    const query = `
        INSERT INTO Clientes (idUsuarios, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    db.query(query, [idUsuarios, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña], (err, result) => {
        if (err) {
            console.error('Error al crear el cliente:', err);
            return res.status(500).send('Error al crear el cliente');
        }
        res.status(201).json({ message: 'Cliente creado correctamente', id: result.insertId });
    });
});

// Actualizar un cliente
router.put('/:idUsuarios/:tipodocumento', (req, res) => {
    const { idUsuarios, tipodocumento } = req.params;
    const { nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña } = req.body;
    const query = `
        UPDATE Clientes
        SET nombre = ?, apellido = ?, direccion = ?, email = ?, telefono = ?, fechanacimiento = ?, contraseña = ?
        WHERE idUsuarios = ? AND tipodocumento = ?`;
    db.query(query, [nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, idUsuarios, tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al actualizar el cliente:', err);
            return res.status(500).send('Error al actualizar el cliente');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Cliente no encontrado');
        }
        res.json({ message: 'Cliente actualizado correctamente' });
    });
});

// Actualizar un cliente por id
router.put('/:idUsuarios', (req, res) => {
    const { idUsuarios } = req.params;
    const { nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña } = req.body;
    const query = `
        UPDATE Clientes
        SET nombre = ?, apellido = ?, direccion = ?, email = ?, telefono = ?, fechanacimiento = ?, contraseña = ?
        WHERE idUsuarios = ?`;
    db.query(query, [nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, idUsuarios], (err, result) => {
        if (err) {
            console.error('Error al actualizar el cliente:', err);
            return res.status(500).send('Error al actualizar el cliente');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Cliente no encontrado');
        }
        res.json({ message: 'Cliente actualizado correctamente' });
    });
});

// Eliminar un cliente
router.delete('/:idUsuarios/:tipodocumento', (req, res) => {
    const { idUsuarios, tipodocumento } = req.params;
    const query = 'DELETE FROM Clientes WHERE idUsuarios = ? AND tipodocumento = ?';
    db.query(query, [idUsuarios, tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al eliminar el cliente:', err);
            return res.status(500).send('Error al eliminar el cliente');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Cliente no encontrado');
        }
        res.json({ message: 'Cliente eliminado correctamente' });
    });
});

module.exports = router;
