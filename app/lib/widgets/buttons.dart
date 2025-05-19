import 'package:app/utils/api.dart';
import 'package:app/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Buttons extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  final int id;
  final int idUser;

  const Buttons({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.precio,
    required this.id,
    required this.idUser,
  }) : super(key: key);

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool isFavorite = false;
  bool isInMyList = false;
  bool isInCart = false;

  final Color mintGreen = Color(0xFF3EB489);

  @override
  void initState() {
    super.initState();
    _loadInitialStates();
  }

  Future<void> _loadInitialStates() async {
    try {
      bool favorite =
          await ProductService().isFavorite(widget.idUser, widget.id);
      bool inCart = await ProductService().isInCart(widget.idUser, widget.id);

      // Verificar si el widget sigue montado antes de llamar a setState
      if (mounted) {
        setState(() {
          isFavorite = favorite;
          isInCart = inCart;
        });
      }
    } catch (e) {
      print('Error al cargar los estados iniciales: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Botón de Favoritos
        Column(
          children: [
            IconButton(
              onPressed: () async {
                // Lógica para manejar favoritos similar al carrito
                final bool isCurrentlyFavorite = isFavorite;
                final actionMessage = isCurrentlyFavorite
                    ? '${widget.title} eliminado de Favoritos'
                    : '${widget.title} añadido a Favoritos';

                final bool result = isCurrentlyFavorite
                    ? await ProductService()
                        .removeFromFavorites(widget.idUser, widget.id)
                    : await ProductService()
                        .createLike(widget.idUser, widget.id);

                if (result) {
                  setState(() {
                    isFavorite = !isCurrentlyFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(actionMessage)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar Favoritos')),
                  );
                }
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                color: isFavorite ? mintGreen : Colors.white,
              ),
            ),
            Text(
              "Favoritos",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        // Botón de Carrito
        Column(
          children: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    int selectedQuantity = 1;

                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Selecciona la cantidad',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (selectedQuantity > 1) {
                                        setState(() {
                                          selectedQuantity--;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text(
                                    selectedQuantity.toString(),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedQuantity++;
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  try {
                                    final response =
                                        await ProductService().addToCart(
                                      selectedQuantity,
                                      widget.idUser,
                                      widget.id,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response['message'])),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error al agregar al carrito'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Text('Añadir al carrito'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: isInCart ? Colors.green : Colors.white,
              ),
            ),
            Text(
              "Agregar al carrito", // Texto debajo del ícono del carrito
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        // Botón de Mi Lista
        Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.comment,
                color: isInMyList ? mintGreen : Colors.white,
              ),
            ),
            Text(
              "Agregar comentario",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        // Botón de Compartir
        Column(
          children: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Compartir ${widget.title}')),
                );
              },
              icon: Icon(Icons.share, color: Colors.white),
            ),
            Text(
              "Compartir",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
