import 'package:app/widgets/bottom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageItem extends StatelessWidget {
  const ImageItem(
      {super.key,
      required this.description,
      required this.imageUrl,
      required this.title,
      required this.precio});
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return CustomBottomSheet(
            title: title,
            description: description,
            imageUrl: imageUrl,
            precio: precio,
          );
        },
      ),
      child: Row(
        children: <Widget>[
          Image.network(
            imageUrl,
            width: 100,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Icon(
                Icons.error,
                color: Colors.white,
              ); // Muestra un ícono en caso de error
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
