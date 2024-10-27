import 'package:flutter/widgets.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.network(
          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Arepitas_Food_Macro.jpg/273px-Arepitas_Food_Macro.jpg",
          width: 100,
          height: 110,
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
