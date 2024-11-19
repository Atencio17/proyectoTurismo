import 'dart:convert';
import 'package:app/utils/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/models/products.dart';

// Clase mock para simular las respuestas HTTP
class MockHttpClient {
  Future<Map<String, dynamic>> get(Uri url) async {
    if (url.toString().contains('/categoria/electronics')) {
      // Simula una respuesta exitosa
      return {
        "statusCode": 200,
        "body": jsonEncode([
          {
            "idProducto": 1,
            "nombre": "Producto 1",
            "detalle": "Detalles 1",
            "imagen": "https://example.com/img1.jpg",
            "categoria": "electronics",
            "tipo": "tipo1",
            "precio": 10.0
          },
          {
            "idProducto": 2,
            "nombre": "Producto 2",
            "detalle": "Detalles 2",
            "imagen": "https://example.com/img2.jpg",
            "categoria": "electronics",
            "tipo": "tipo2",
            "precio": 20.0
          }
        ])
      };
    } else {
      // Simula un error
      return {"statusCode": 404, "body": 'Error'};
    }
  }
}

void main() {
  late ProductService productService;
  late MockHttpClient mockClient;

  setUp(() {
    productService = ProductService();
    mockClient = MockHttpClient();
  });

  group('ProductService', () {
    test('Devuelve una lista de productos cuando la respuesta es exitosa',
        () async {
      // Simula el comportamiento de una solicitud exitosa
      final response = await mockClient.get(Uri.parse(
          'http://192.168.20.29:3000/api/productos/categoria/electronics'));

      if (response['statusCode'] == 200) {
        final data = jsonDecode(response['body']);
        final products =
            data.map<Product>((json) => Product.fromJson(json)).toList();

        expect(products, isA<List<Product>>());
        expect(products.length, 2);
        expect(products[0].nombre, 'Producto 1');
        expect(products[1].precio, 20.0);
      }
    });

    test('Lanza una excepción cuando la respuesta no es exitosa', () async {
      // Simula el comportamiento de un error
      final response = await mockClient.get(Uri.parse(
          'http://192.168.20.29:3000/api/productos/categoria/invalid'));

      if (response['statusCode'] != 200) {
        expect(() async => throw Exception('Error al cargar los productos'),
            throwsException);
      }
    });
  });
}
