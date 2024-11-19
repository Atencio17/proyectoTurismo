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

  Future<void> createUser(String id, String name, String lastName, String date,
      String password) async {
    final url =
        '$baseUrl/usuarios'; // Cambia la URL según tu configuración de servidor

    // Construimos el cuerpo de la solicitud
    final Map<String, dynamic> userData = {
      'idUsuario': id,
      'nombre': name,
      'apellido': lastName,
      'fechaNacimiento': date,
      'contraseña': password,
      'tipo': 'cliente'
    };

    try {
      // Hacemos la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        // Usuario creado exitosamente
        print('Usuario creado: ${response.body}');
      } else {
        // Algo salió mal
        print('Error al crear el usuario: ${response.body}');
        throw Exception('Error al crear el usuario');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      throw Exception('Error en la solicitud');
    }
  }

  Future<bool> validateUser(String idUsuario, String password) async {
    final url = Uri.parse('$baseUrl/usuarios/$idUsuario');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Usuario encontrado, verificar contraseña
        final data = jsonDecode(response.body);
        final serverPassword =
            data['contraseña']; // Asegúrate de que el campo coincida
        return serverPassword == password;
      } else if (response.statusCode == 404) {
        // Usuario no encontrado
        print('Usuario no encontrado');
        return false;
      } else {
        // Otros errores
        throw Exception(
            'Error al consultar el usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
