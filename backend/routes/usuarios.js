const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los usuarios
router.get('/', (req, res) => {
    const query = 'SELECT * FROM usuarios';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los usuarios:', err);
            return res.status(500).send('Error al obtener los usuarios');
        }
        res.json(results);
    });
});

// Obtener un usuario por ID
router.get('/:idUsuario', (req, res) => {
    const { idUsuario } = req.params;
    const query = 'SELECT * FROM usuarios WHERE idUsuario = ?';
    db.query(query, [idUsuario], (err, results) => {
        if (err) {
            console.error('Error al obtener el usuario:', err);
            return res.status(500).send('Error al obtener el usuario');
        }
        if (results.length === 0) {
            return res.status(404).send('Usuario no encontrado');
        }
        res.json(results[0]);
    });
});

// Crear un nuevo usuario
router.post('/', (req, res) => {
    const { idUsuario, nombre, apellido, fechaNacimiento, contraseña, tipo } = req.body;

    // Verificar si el idUsuario ya existe
    const checkQuery = 'SELECT * FROM usuarios WHERE idUsuario = ?';
    db.query(checkQuery, [idUsuario], (err, results) => {
        if (err) {
            console.error('Error al verificar si el idUsuario ya existe:', err);
            return res.status(500).send('Error al verificar el idUsuario');
        }
        if (results.length > 0) {
            return res.status(400).send('El idUsuario ya existe');
        }

        const query = 'INSERT INTO usuarios (idUsuario, nombre, apellido, fechaNacimiento, contraseña, tipo) VALUES (?, ?, ?, ?, ?, ?)';
        db.query(query, [idUsuario, nombre, apellido, fechaNacimiento, contraseña, tipo], (err, result) => {
            if (err) {
                console.error('Error al crear el usuario:', err);
                return res.status(500).send('Error al crear el usuario');
            }
            res.status(201).json({
                idUsuario,
                nombre,
                apellido,
                fechaNacimiento,
                contraseña,
                tipo
            });
        });
    });
});

// Actualizar un usuario
router.put('/:idUsuario', (req, res) => {
    const { idUsuario } = req.params;
    const { nombre, apellido, fechaNacimiento, contraseña, tipo } = req.body;

    const query = `
        UPDATE usuarios 
        SET nombre = ?, apellido = ?, fechaNacimiento = ?, contraseña = ?, tipo = ?
        WHERE idUsuario = ?`;
    db.query(query, [nombre, apellido, fechaNacimiento, contraseña, tipo, idUsuario], (err, result) => {
        if (err) {
            console.error('Error al actualizar el usuario:', err);
            return res.status(500).send('Error al actualizar el usuario');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Usuario no encontrado');
        }
        res.json({ message: 'Usuario actualizado correctamente' });
    });
});

// Eliminar un usuario
router.delete('/:idUsuario', (req, res) => {
    const { idUsuario } = req.params;
    const query = 'DELETE FROM usuarios WHERE idUsuario = ?';
    db.query(query, [idUsuario], (err, result) => {
        if (err) {
            console.error('Error al eliminar el usuario:', err);
            return res.status(500).send('Error al eliminar el usuario');
        }
        if (result.affectedRows === 0) {
            return res.status(404).send('Usuario no encontrado');
        }
        res.json({ message: 'Usuario eliminado correctamente' });
    });
});

module.exports = router;
