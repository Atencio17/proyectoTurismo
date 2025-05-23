import 'package:app/models/products.dart';
import 'package:app/screens/home.dart';
import 'package:app/utils/api.dart';
import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.precio,
      required this.id,
      required this.idUser});
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  final int id;
  final int idUser;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailScreen(
        description: description,
        imageUrl: imageUrl,
        title: title,
        precio: precio,
        id: id,
        idUser: idUser);
  }
}

class _DetailScreen extends State<DetailScreen> {
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  final int id;
  final int idUser;
  _DetailScreen(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.precio,
      required this.id,
      required this.idUser});

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List<Product> listaConcatenada = [];

  void getData() async {
    List<Product> auxF = await ProductService().getProductsByCategory("Frutas");
    List<Product> auxV =
        await ProductService().getProductsByCategory("Verduras");
    List<Product> auxS =
        await ProductService().getProductsByCategory("Semillas");
    List<Product> auxC = await ProductService().getProductsByCategory("Carnes");
    setState(() {
      listaConcatenada = auxC + auxS + auxV + auxF;
      listaConcatenada.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            SizedBox(height: 16),

            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Descripción
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Precio: \$$precio",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Buttons(
                title: title,
                description: description,
                imageUrl: imageUrl,
                precio: precio,
                id: id,
                idUser: idUser,
              ),
            ),
            horizontalList("Categorias parecidas", listaConcatenada, 1, idUser),
          ],
        ),
      ),
    );
  }
}
