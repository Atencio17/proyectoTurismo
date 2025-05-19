import 'package:app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        recommendation(),
        info(),
      ],
    );
  }
}

Widget recommendation() {
  return Stack(
    children: <Widget>[
      Image.network(
        "https://www.viveelmeta.com/wp-content/uploads/2021/01/cierran-fruver-3954.jpg",
        height: 350,
        fit: BoxFit.cover,
      ),
      Container(
        width: double.infinity,
        height: 350,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.black38,
              Colors.black,
            ],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      SafeArea(
        child: NavBarTop(),
      ),
    ],
  );
}

Widget info() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Frutas",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      SizedBox(
        width: 6,
      ),
      Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
        size: 5,
      ),
      SizedBox(
        width: 6,
      ),
      Text(
        "Verduras",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      SizedBox(
        width: 6,
      ),
      Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
        size: 5,
      ),
      SizedBox(
        width: 6,
      ),
      Text(
        "Semillas",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      SizedBox(
        width: 6,
      ),
      Icon(
        Icons.fiber_manual_record,
        color: Colors.red,
        size: 5,
      ),
      SizedBox(
        width: 6,
      ),
      Text(
        "Carnes",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      SizedBox(
        width: 6,
      ),
    ],
  );
}
