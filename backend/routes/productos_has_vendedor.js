const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtener todos los registros de Productos_has_Vendedor
router.get('/', (req, res) => {
    const query = 'SELECT * FROM Productos_has_Vendedor';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al obtener los registros de Productos_has_Vendedor:', err);
            return res.status(500).send('Error al obtener los registros');
        }
        res.json(results);
    });
});

// Obtener un registro específico
router.get('/:idProductos/:idVendedor/:tipodocumento', (req, res) => {
    const { idProductos, idVendedor, tipodocumento } = req.params;
    const query = `
        SELECT * 
        FROM Productos_has_Vendedor 
        WHERE Productos_idProductos = ? 
        AND Vendedor_idVendedor = ? 
        AND Vendedor_tipodocumento = ?`;
    db.query(query, [idProductos, idVendedor, tipodocumento], (err, results) => {
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
    const { Productos_idProductos, Vendedor_idVendedor, Vendedor_tipodocumento } = req.body;
    const query = `
        INSERT INTO Productos_has_Vendedor (Productos_idProductos, Vendedor_idVendedor, Vendedor_tipodocumento)
        VALUES (?, ?, ?)`;
    db.query(query, [Productos_idProductos, Vendedor_idVendedor, Vendedor_tipodocumento], (err, result) => {
        if (err) {
            console.error('Error al crear el registro:', err);
            return res.status(500).send('Error al crear el registro');
        }
        res.status(201).json({ message: 'Registro creado correctamente' });
    });
});

// Actualizar un registro
router.put('/:idProductos/:idVendedor/:tipodocumento', (req, res) => {
    const { idProductos, idVendedor, tipodocumento } = req.params;
    const { Productos_idProductos, Vendedor_idVendedor, Vendedor_tipodocumento } = req.body;
    const query = `
        UPDATE Productos_has_Vendedor
        SET Productos_idProductos = ?, Vendedor_idVendedor = ?, Vendedor_tipodocumento = ?
        WHERE Productos_idProductos = ? AND Vendedor_idVendedor = ? AND Vendedor_tipodocumento = ?`;
    db.query(
        query,
        [Productos_idProductos, Vendedor_idVendedor, Vendedor_tipodocumento, idProductos, idVendedor, tipodocumento],
        (err, result) => {
            if (err) {
                console.error('Error al actualizar el registro:', err);
                return res.status(500).send('Error al actualizar el registro');
            }
            if (result.affectedRows === 0) {
                return res.status(404).send('Registro no encontrado');
            }
            res.json({ message: 'Registro actualizado correctamente' });
        }
    );
});

// Eliminar un registro
router.delete('/:idProductos/:idVendedor/:tipodocumento', (req, res) => {
    const { idProductos, idVendedor, tipodocumento } = req.params;
    const query = `
        DELETE FROM Productos_has_Vendedor
        WHERE Productos_idProductos = ? AND Vendedor_idVendedor = ? AND Vendedor_tipodocumento = ?`;
    db.query(query, [idProductos, idVendedor, tipodocumento], (err, result) => {
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
