import 'package:dima_project/layout_dimension.dart';
import 'package:flutter/material.dart';

class UpperGradientPictureBookShelf extends StatelessWidget {
  const UpperGradientPictureBookShelf({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: Key("BookShelf"),
      children: <Widget>[
        Container(
          height: height * 0.3,
          width: width,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/bookshelf.png"), fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.75),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 20,
          child: RichText(
            key: Key("richtext"),
            text: TextSpan(
              text: "BookShelf",
              style: TextStyle(color: Colors.deepPurple[50], fontWeight: FontWeight.w500, fontSize: 45, decorationColor: Colors.deepPurple),
            ),
          ),
        )
      ],
    );
  }
}
