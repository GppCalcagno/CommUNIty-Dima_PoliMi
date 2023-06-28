// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UpperGradientPicturePosition extends StatelessWidget {
  const UpperGradientPicturePosition({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: Key("Network"),
      children: <Widget>[
        Container(
          height: height * 0.3,
          width: width,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/network.png"), fit: BoxFit.cover)),
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
              text: "Network",
              style: TextStyle(color: Colors.deepPurple[50], fontWeight: FontWeight.w500, fontSize: 45, decorationColor: Colors.deepPurple),
            ),
          ),
        )
      ],
    );
  }
}
