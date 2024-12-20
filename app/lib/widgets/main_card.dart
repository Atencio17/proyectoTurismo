import 'package:app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        recommendation(),
        info(),
        buttonsAction(),
      ],
    );
  }
}

Widget recommendation() {
  return Stack(
    children: <Widget>[
      Image.network(
        "https://artesaniasdecolombia.com.co/Documentos/Contenido/42960_imagen_pequena_nota_cierre_folkart-01.jpg",
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
        "Artesanías",
        style: TextStyle(color: Colors.white, fontSize: 10),
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
        "Cultura",
        style: TextStyle(color: Colors.white, fontSize: 10),
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
        "Ancestrales",
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
      SizedBox(
        width: 6,
      ),
    ],
  );
}

Widget buttonsAction() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Column(
          children: [
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "Mi lista",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.touch_app,
            color: Colors.black,
          ),
          label: const Text("Observar"),
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white)),
        ),
        const Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "Informacion",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        )
      ],
    ),
  );
}
