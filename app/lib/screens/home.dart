import 'package:app/models/products.dart';
import 'package:app/utils/data.dart';
import 'package:app/utils/getProducts.dart';
import 'package:app/widgets/circle_item.dart';
import 'package:app/widgets/image_item.dart';
import 'package:app/widgets/main_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  List<Product> listaGastronomia = [];
  List<Product> listaArtesanias = [];
  List<Product> listaAvances = [];
  int _selectedIndex = 0; // Índice del icono seleccionado

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Product> auxG =
        await ProductService().getProductsByCategory("Gastronomía");
    List<Product> auxA =
        await ProductService().getProductsByCategory("Artesanía");
    setState(() {
      listaGastronomia = auxG;
      listaArtesanias = auxA;
      listaAvances = listaArtesanias + listaGastronomia;
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
          homePageBody(), // Página de inicio
          searchPageBody(), // Página de búsqueda
          cartPageBody(), // Página del carrito
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
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.search),
          //  label: "Buscar",
          //),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: "Carrito",
          ),
        ],
      ),
    );
  }

  Widget homePageBody() {
    return ListView(
      children: <Widget>[
        MainCard(),
        horizontalList("Avances", listaAvances, 2),
        SizedBox(height: 10),
        listaGastronomia.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Gastronomía", listaGastronomia, 1),
        SizedBox(height: 10),
        listaArtesanias.isEmpty
            ? Center(child: CircularProgressIndicator())
            : horizontalList("Artesanía", listaArtesanias, 1),
        SizedBox(height: 20),
      ],
    );
  }

  Widget searchPageBody() {
    return Center(
      child: Text(
        'Página de búsqueda',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget cartPageBody() {
    return AppData.cart.isEmpty
        ? Center(
            child: Text(
              'Tu carrito está vacío',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        : Column(
            children: [
              Expanded(
                // Aseguramos que ListView ocupe el espacio disponible
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: AppData.cart.length,
                  itemBuilder: (context, index) {
                    final product = AppData.cart[index];
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
                                product['imageUrl'],
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
                                    product['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    product['description'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Precio: \$${product['price']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  AppData.removeFromCart(product);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      '${product['title']} se quitó del carrito',
                                    ),
                                  ));
                                });
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
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
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
                                'Total: \$${calculateTotal()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // Aquí agregas la lógica para confirmar el pago
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Pago confirmado'),
                                  ));
                                },
                                child: Text('Confirmar Pago'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Pagar',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
  }

// Función para calcular el total
  double calculateTotal() {
    double total = 0.0;

    // Iterar sobre cada producto en el carrito y sumar el precio
    for (var product in AppData.cart) {
      // Asegurarse de que el precio sea un número válido
      double price = double.tryParse(product['price'].toString()) ?? 0.0;
      total += price;
    }

    return total;
  }
}

Widget horizontalList(String titulo, List<Product> items, int tipo) {
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
                    imageUrl: items[index].imagen,
                    title: items[index].nombre,
                    precio: items[index].precio.toString(),
                  )
                : CircleItem(
                    description: items[index].detalle,
                    imageUrl: items[index].imagen,
                    title: items[index].nombre,
                    precio: items[index].precio.toString(),
                  );
          },
        ),
      ),
    ],
  );
}
