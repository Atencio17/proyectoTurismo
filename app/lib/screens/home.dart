import 'package:app/widgets/circle_item.dart';
import 'package:app/widgets/image_item.dart';
import 'package:app/widgets/main_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          MainCard(),
          horizontalList("Avances", CircleItem(), 9),
          SizedBox(
            height: 10,
          ),
          horizontalList("Gastronomia", ImageItem(), 9),
          SizedBox(
            height: 10,
          ),
          horizontalList("Gastronomia", ImageItem(), 9),
          SizedBox(
            height: 10,
          ),
          horizontalList("Gastronomia", ImageItem(), 9),
          SizedBox(
            height: 20,
          )
        ],
      ),
      bottomNavigationBar: navBottom(),
    );
  }
}

BottomNavigationBar navBottom() {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white54,
    type: BottomNavigationBarType.fixed,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Inicio",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Buscar",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz),
        label: "Más",
      ),
    ],
  );
}

Widget horizontalList(String titulo, Widget item, int cantidad) {
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
          itemCount: cantidad,
          itemBuilder: (context, index) {
            return item;
          },
        ),
      ),
    ],
  );
}
