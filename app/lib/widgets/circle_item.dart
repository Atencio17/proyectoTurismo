import 'package:app/widgets/bottom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleItem extends StatelessWidget {
  const CircleItem({
    super.key,
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.precio,
    required this.id,
    required this.idUser,
  });
  final String title;
  final String description;
  final String imageUrl;
  final String precio;
  final int id;
  final int idUser;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return CustomBottomSheet(
                title: title,
                description: description,
                imageUrl: imageUrl,
                precio: precio,
                id: id,
                idUser: idUser,
              );
            },
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(110),
                  border: Border.all(
                    color: Colors.yellow,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Icon(
                        Icons.error,
                        color: Colors.white,
                      ); // Muestra un ícono en caso de error
                    },
                  ),
                ),
              ),
              Container(
                width: 100,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
