import 'dart:convert';
import 'package:app/models/products.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl =
      'http://192.168.6.137:3000/api'; // Cambia esto por la URL de tu API

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

  Future<void> createUser(
      String id,
      String tipoId,
      String nombre,
      String apellido,
      String address,
      String email,
      String phone,
      String date,
      String password) async {
    final url =
        '$baseUrl/clientes'; // Cambia la URL según tu configuración de servidor

    // Construimos el cuerpo de la solicitud
    final Map<String, dynamic> userData = {
      'idUsuarios': id,
      'tipodocumento': tipoId,
      'nombre': nombre,
      'apellido': apellido,
      'direccion': address,
      'email': email,
      'telefono': phone,
      'fechanacimiento': date,
      'contraseña': password,
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
    final url = Uri.parse('$baseUrl/clientes/$idUsuario');
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

  Future<Map<String, dynamic>> getUserData(String id) async {
    final url = Uri.parse(
        '$baseUrl/clientes/$id'); // Usar el idUsuario del usuario actual

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar los datos del usuario');
    }
  }

  // Función para actualizar los datos del usuario
  Future<bool> updateUserData(
      String id,
      String nombre,
      String apellido,
      String direccion,
      String email,
      String telefono,
      String fechaNacimiento,
      String password) async {
    final url =
        Uri.parse('$baseUrl/clientes/$id'); // Asegúrate de tener el idUsuario

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'email': email,
        'telefono': telefono,
        'fechanacimiento': fechaNacimiento,
        'contraseña': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> addToCart(
      int quantity, int userId, int productId) async {
    final url = Uri.parse("$baseUrl/carrito");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "cantidad": quantity,
        "Clientes_idUsuarios": userId,
        "Productos_idProductos": productId
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al agregar al carrito: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final url = Uri.parse('$baseUrl/carrito/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los productos del carrito');
    }
  }

  Future<bool> removeFromCart(int productId) async {
    final url = Uri.parse("$baseUrl/carrito/$productId");
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getCartWithProducts(String userId) async {
    try {
      final cartUrl = Uri.parse('$baseUrl/carrito/$userId');
      final cartResponse = await http.get(cartUrl);

      if (cartResponse.statusCode != 200) {
        throw Exception('Error al obtener el carrito: ${cartResponse.body}');
      }

      List<dynamic> cartItems = jsonDecode(cartResponse.body);
      if (cartItems.isEmpty) {
        return []; // Devuelve una lista vacía si el carrito está vacío
      }

      List<Map<String, dynamic>> fullCartDetails = [];

      for (var item in cartItems) {
        final productId = item['Productos_idProductos'];

        final productResponse =
            await http.get(Uri.parse('$baseUrl/productos/$productId'));

        if (productResponse.statusCode == 200) {
          Map<String, dynamic> productDetails =
              jsonDecode(productResponse.body);

          // Combina los datos del carrito con los del producto
          fullCartDetails.add({
            ...item,
            ...productDetails,
          });
        } else {
          print(
              'Error al obtener el producto $productId: ${productResponse.body}');
        }
      }

      return fullCartDetails;
    } catch (e) {
      print('Error en getCartWithProducts: $e');
      rethrow; // Re-lanzar el error para manejo adicional
    }
  }

  Future<bool> createLike(int userId, int productId) async {
    final url = Uri.parse("$baseUrl/likes");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"Clientes_idUsuarios": userId, "Productos_idProductos": productId}),
    );
    return response.statusCode == 201;
  }

  Future<bool> removeFromFavorites(int userId, int productId) async {
    final url = Uri.parse("$baseUrl/likes");
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"Clientes_idUsuarios": userId, "Productos_idProductos": productId}),
    );
    return response.statusCode == 200;
  }

  Future<bool> isInCart(int userId, int productId) async {
    final url = Uri.parse("$baseUrl/carrito/$userId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.any((item) => item['Productos_idProductos'] == productId);
    }
    return false;
  }

  Future<bool> isFavorite(int userId, int productId) async {
    final url = Uri.parse(
        "$baseUrl/likes/$userId"); // URL ajustada para obtener los likes de un usuario
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data =
          jsonDecode(response.body); // Decodificamos la respuesta como lista

      // Verificamos si alguno de los elementos en la lista de likes tiene el id del producto
      return data.any((item) => item['Productos_idProductos'] == productId);
    }
    return false; // Si la respuesta no es exitosa, asumimos que el producto no está en favoritos
  }
}
