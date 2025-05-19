import 'package:app/models/products.dart';
import 'package:app/utils/data.dart';
import 'package:app/utils/api.dart';
import 'package:app/widgets/circle_item.dart';
import 'package:app/widgets/image_item.dart';
import 'package:app/widgets/main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  final String? id;
  HomePage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  List<Product> listaFrutas = [];
  List<Product> listaVerduras = [];
  List<Product> listaSemillas = [];
  List<Product> listaAvances = [];
  List<Product> listaCarnes = [];
  int _selectedIndex = 0; // Índice del icono seleccionado
  String? id;

  @override
  void initState() {
    super.initState();
    getData();
    id = widget.id!;
  }

  void getData() async {
    List<Product> auxF = await ProductService().getProductsByCategory("Frutas");
    List<Product> auxV =
        await ProductService().getProductsByCategory("Verduras");
    List<Product> auxS =
        await ProductService().getProductsByCategory("Semillas");
    List<Product> auxC = await ProductService().getProductsByCategory("Carnes");
    setState(() {
      listaFrutas = auxF;
      listaVerduras = auxV;
      listaSemillas = auxS;
      listaCarnes = auxC;
      listaAvances = listaFrutas + listaVerduras + listaSemillas + listaCarnes;
      listaAvances.shuffle();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex, // Muestra la sección correspondiente al índice
        children: <Widget>[
          homePageBody(int.parse(id!)), // Página de inicio
          cartPageBody(), // Página del carrito
          profilePageBody(id!), // Página de perfil
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Indica el icono seleccionado
        onTap: _onItemTapped, // Llama al método al hacer clic en un icono
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: "Carrito",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  Widget homePageBody(int id) {
    return ListView(
      children: <Widget>[
        MainCard(),
        horizontalList("Destacado", listaAvances, 2, id),
        SizedBox(height: 10),
        listaFrutas.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Frutas", listaFrutas, 1, id),
        SizedBox(height: 10),
        listaVerduras.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Verduras", listaVerduras, 1, id),
        SizedBox(height: 10),
        listaSemillas.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Semillas", listaSemillas, 1, id),
        SizedBox(height: 10),
        listaCarnes.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Carnes", listaCarnes, 1, id),
        SizedBox(height: 20),
      ],
    );
  }

  // Cambié esta parte para utilizar FutureBuilder
  Widget profilePageBody(String id) {
    String formatFecha(String fechaIso) {
      // Parsear la fecha ISO a un objeto DateTime
      DateTime fecha = DateTime.parse(fechaIso);

      // Extraer los componentes necesarios
      String year = fecha.year.toString();
      String day = fecha.day
          .toString()
          .padLeft(2, '0'); // Asegura que el día tenga 2 dígitos
      String month = fecha.month
          .toString()
          .padLeft(2, '0'); // Asegura que el mes tenga 2 dígitos

      // Formatear la fecha en el formato deseado
      return '$year-$day-$month';
    }

    TextEditingController nombreController = TextEditingController();
    TextEditingController apellidoController = TextEditingController();
    TextEditingController direccionController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();
    TextEditingController fechaNacimientoController = TextEditingController();

    return FutureBuilder<Map<String, dynamic>>(
      future: ProductService().getUserData(id), // Aquí llamas la API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Mientras cargan los datos
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // En caso de error
        }

        if (!snapshot.hasData) {
          return Center(
              child: Text('No se encontraron datos')); // Si no hay datos
        }

        var userData = snapshot.data!; // Obtener los datos

        nombreController.text = userData['nombre'];
        apellidoController.text = userData['apellido'];
        direccionController.text = userData['direccion'];
        emailController.text = userData['email'];
        telefonoController.text = userData['telefono'];
        fechaNacimientoController.text =
            formatFecha(userData['fechanacimiento']);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 100),
                  child: Center(
                    child: Text(
                      'Actualizar mis datos',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                ),
                _buildTextField('Nombre', nombreController),
                _buildTextField('Apellido', apellidoController),
                _buildTextField('Dirección', direccionController),
                _buildTextField('Email', emailController),
                _buildTextField('Teléfono', telefonoController),
                _buildTextField(
                    'Fecha de Nacimiento', fechaNacimientoController),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await ProductService().updateUserData(
                        id,
                        nombreController.text,
                        apellidoController.text,
                        direccionController.text,
                        emailController.text,
                        telefonoController.text,
                        fechaNacimientoController.text,
                        userData['contraseña'],
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Datos actualizados correctamente')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error al actualizar los datos')),
                        );
                      }
                    },
                    child: Text('Actualizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3EB489),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget cartPageBody() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future:
          ProductService().getCartWithProducts(widget.id!), // Llama a la API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Muestra un indicador de carga
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar el carrito: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Tu carrito está vacío',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }

        List<Map<String, dynamic>> cartItems = snapshot.data!;
        double subtotal = calculateTotal(cartItems); // Calcula el subtotal

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'http://192.168.6.137:3000/uploads/' +
                                    item['imagen'], // Imagen del producto
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nombre'], // Título del producto
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    item['detalle'], // Descripción del producto
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Cantidad: ${item['cantidad']}", // Cantidad en el carrito
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Precio: \$${item['precio']}", // Precio unitario
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                bool success = await ProductService()
                                    .removeFromCart(item[
                                        'Productos_idProductos']); // ID del carrito
                                if (success) {
                                  setState(() {}); // Recargar el carrito
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${item['nombre']} se quitó del carrito'),
                                    ),
                                  );
                                }
                              },
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () {
                    // Acción del botón
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Resumen de Compra'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total: \$${subtotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Pago confirmado'),
                                    ),
                                  );
                                },
                                child: Text('Confirmar Pago'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pagar',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double calculateTotal(List<Map<String, dynamic>> cartItems) {
    double total = 0.0;

    for (var item in cartItems) {
      // Verificar que 'precio' y 'cantidad' existan y no sean nulos
      if (item['precio'] != null && item['cantidad'] != null) {
        double price = double.tryParse(item['precio'].toString()) ?? 0.0;
        int cantidad = int.tryParse(item['cantidad'].toString()) ?? 0;

        // Calcular el subtotal (precio * cantidad) y sumarlo al total
        total += price * cantidad;
      }
    }

    return total;
  }
}

Widget horizontalList(
    String titulo, List<Product> items, int tipo, int idUser) {
  final String baseUrl = 'http://192.168.6.137:3000/uploads/';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Text(
          titulo,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Container(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return tipo == 1
                ? ImageItem(
                    description: items[index].detalle,
                    imageUrl: baseUrl + items[index].imagen,
                    title: items[index].nombre,
                    precio: items[index].precio.toString(),
                    id: items[index].idProductos,
                    idUser: idUser,
                  )
                : CircleItem(
                    description: items[index].detalle,
                    imageUrl: baseUrl + items[index].imagen,
                    title: items[index].nombre,
                    precio: items[index].precio.toString(),
                    id: items[index].idProductos,
                    idUser: idUser,
                  );
          },
        ),
      ),
    ],
  );
}
