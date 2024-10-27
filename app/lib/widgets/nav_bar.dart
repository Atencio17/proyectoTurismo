import 'package:flutter/material.dart';

class NavBarTop extends StatelessWidget {
  const NavBarTop({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          "App",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "Actividades",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "Regalos",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          "Mi lista",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
