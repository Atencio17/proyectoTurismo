import 'package:app/utils/data.dart';
import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  const Buttons({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.precio,
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
  Widget build(BuildContext context) {
    final item = {
      'title': widget.title,
      'description': widget.description,
      'imageUrl': widget.imageUrl,
      'price': widget.precio.toString()
    };

    void toggleItem({
      required bool isActive,
      required void Function(Map<String, dynamic>) addAction,
      required void Function(Map<String, dynamic>) removeAction,
      required String addMessage,
      required String removeMessage,
    }) {
      setState(() {
        isActive = !isActive;
      });

      if (isActive) {
        addAction(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(addMessage)),
        );
      } else {
        removeAction(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(removeMessage)),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Botón de Favoritos
        Column(
          children: [
            IconButton(
              onPressed: () {
                toggleItem(
                  isActive: isFavorite,
                  addAction: AppData.addToFavorites,
                  removeAction: AppData.removeFromFavorites,
                  addMessage: '${widget.title} añadido a Favoritos',
                  removeMessage: '${widget.title} eliminado de Favoritos',
                );
                setState(() {
                  isFavorite = !isFavorite;
                });
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
                toggleItem(
                  isActive: isInCart,
                  addAction: AppData.addToCart,
                  removeAction: AppData.removeFromCart,
                  addMessage: '${widget.title} añadido al Carrito',
                  removeMessage: '${widget.title} eliminado del Carrito',
                );
                setState(() {
                  isInCart = !isInCart;
                });
              },
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: isInCart ? mintGreen : Colors.white,
              ),
            ),
            Text(
              "Carrito",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        // Botón de Mi Lista
        Column(
          children: [
            IconButton(
              onPressed: () {
                toggleItem(
                  isActive: isInMyList,
                  addAction: AppData.addToMyList,
                  removeAction: AppData.removeFromMyList,
                  addMessage: '${widget.title} añadido a Mi Lista',
                  removeMessage: '${widget.title} eliminado de Mi Lista',
                );
                setState(() {
                  isInMyList = !isInMyList;
                });
              },
              icon: Icon(
                isInMyList ? Icons.check : Icons.add,
                color: isInMyList ? mintGreen : Colors.white,
              ),
            ),
            Text(
              "Mi lista",
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
