const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los vendedores
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Vendedor';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los vendedores:', err);
            return res.status(500).send('Error al obtener los vendedores');
        }
        res.json(results);
    });
});

// Obtener un vendedor por ID
router.get('/:idVendedor/:tipodocumento', (req, res) => {
    const { idVendedor, tipodocumento } = req.params;
    const query = 'SELECT * FROM Vendedor WHERE idVendedor = ? AND tipodocumento = ?';
    db.query(query, [idVendedor, tipodocumento], (err, results) => {
        if (err) {
            console.error('Error al obtener el vendedor:', err);
            return res.status(500).send('Error al obtener el vendedor');
        }
        if (results.length === 0) {
            return res.status(404).send('Vendedor no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo vendedor
router.post('/', (req, res) => {
    const { idVendedor, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, sexo } = req.body;
    const query = `
        INSERT INTO Vendedor (idVendedor, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, sexo)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    db.query(query, [idVendedor, tipodocumento, nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, sexo], (err, result) => {
        if (err) {
            console.error('Error al crear el vendedor:', err);
            return res.status(500).send('Error al crear el vendedor');
        }
        res.status(201).json({ message: 'Vendedor creado correctamente', id: result.insertId });
    });
});

// Actualizar un vendedor
router.put('/:idVendedor/:tipodocumento', (req, res) => {
    const { idVendedor, tipodocumento } = req.params;
    const { nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, sexo } = req.body;
    const query = `
        UPDATE Vendedor 
        SET nombre = ?, apellido = ?, direccion = ?, email = ?, telefono = ?, fechanacimiento = ?, contraseña = ?, sexo = ?
        WHERE idVendedor = ? AND tipodocumento = ?`;
    db.query(query, [nombre, apellido, direccion, email, telefono, fechanacimiento, contraseña, sexo, idVendedor, tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al actualizar el vendedor:', err);
            return res.status(500).send('Error al actualizar el vendedor');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Vendedor no encontrado');
        }
        res.json({ message: 'Vendedor actualizado correctamente' });
    });
});

// Eliminar un vendedor
router.delete('/:idVendedor/:tipodocumento', (req, res) => {
    const { idVendedor, tipodocumento } = req.params;
    const query = 'DELETE FROM Vendedor WHERE idVendedor = ? AND tipodocumento = ?';
    db.query(query, [idVendedor, tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al eliminar el vendedor:', err);
            return res.status(500).send('Error al eliminar el vendedor');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Vendedor no encontrado');
        }
        res.json({ message: 'Vendedor eliminado correctamente' });
    });
});

module.exports = router;
