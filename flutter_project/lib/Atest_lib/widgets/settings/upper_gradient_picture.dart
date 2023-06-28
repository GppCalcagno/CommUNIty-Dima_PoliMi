// ignore_for_file: prefer_const_constructors

import 'package:dima_project/layout_dimension.dart';
import 'package:flutter/material.dart';

class UpperGradientPicture extends StatelessWidget {
  const UpperGradientPicture({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    Color color1 = Colors.grey[400]!;
    Color color2 = Colors.black12;
    
    return Stack(
      key: Key("Profile"),
      children: <Widget>[
        SizedBox(
          height: height * 0.12,
          width: width,
          child: Container(
            decoration: //Theme.of(context).brightness == Brightness.light ?
            width < limitWidth ?
            BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color1.withOpacity(0.0),
                  color1.withOpacity(0.1),
                  color1.withOpacity(0.2),
                  color1.withOpacity(0.4),
                  color1.withOpacity(0.75),
                ], 
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter
              )
            ) : 
            BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color2.withOpacity(0.0),
                  color2.withOpacity(0.1),
                  color2.withOpacity(0.2),
                  color2.withOpacity(0.4),
                  color2.withOpacity(0.75),
                ], 
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter
              )
            )
          ),
        ),
        
        Positioned(
          bottom: 40,
          left: 20,
          child: RichText(
            key: Key("richtext"),
            text: TextSpan(
              text: "Profile",
              style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.deepPurple[400] : Colors.deepPurple[50], fontWeight: FontWeight.w500, fontSize: 45, decorationColor: Colors.deepPurple),
            ),
          ),
        )
      ],
    );
  }
}