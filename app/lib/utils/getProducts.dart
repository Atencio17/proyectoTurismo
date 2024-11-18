import 'dart:convert';
import 'package:app/models/products.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl =
      'http://192.168.20.29:3000/api'; // Cambia esto por la URL de tu API

  // Método para obtener productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    final url =
        '$baseUrl/productos/categoria/$category'; // Cambia la URL según tu configuración de servidor
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Si el servidor devuelve una respuesta exitosa, parseamos los datos
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      // Si la respuesta no es exitosa, lanza un error
      throw Exception('Error al cargar los productos');
    }
  }
}
