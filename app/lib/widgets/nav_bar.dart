import 'package:flutter/material.dart';

class NavBarTop extends StatelessWidget {
  const NavBarTop({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: () {},
          child: Image.asset(
            "assets/logo.png",
            height: 40,
            width: 40,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Filtros",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
