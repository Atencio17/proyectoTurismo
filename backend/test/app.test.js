const request = require('supertest');
const app = require('../index');

let server;

beforeAll((done) => {
    server = app.listen(4000, () => {
        console.log('Servidor de pruebas iniciado');
        done();
    });
});

afterAll((done) => {
    server.close(() => {
        console.log('Servidor de pruebas cerrado');
        done();
    });
});

describe('API Test', () => {
    it('GET /api/productos should return 200', async () => {
        const res = await request(server).get('/api/productos');
        expect(res.statusCode).toBe(200);
    });
});
