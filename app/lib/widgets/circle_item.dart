import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleItem extends StatelessWidget {
  const CircleItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
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
                  "https://s3.amazonaws.com/rtvc-assets-canalinstitucional.tv/s3fs-public/2022-01/historia%20del%20sombrero%20vueltiao.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 100,
              child: Text(
                "Sombrero Vueltiao",
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
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
