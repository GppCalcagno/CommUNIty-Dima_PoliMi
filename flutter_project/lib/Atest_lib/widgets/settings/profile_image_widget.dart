import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onClicked;

  const ProfileImageWidget({
      Key? key,
      required this.imageUrl,
      required this.onClicked,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 50,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: buildImage(onClicked)),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color, onClicked)
          ),
        ]
      ),
    );

  }
  
  Widget buildImage(VoidCallback? onClicked) {
    final image = NetworkImage(imageUrl);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        /*child: Ink.image(
          image: image, 
          fit: BoxFit.cover, 
          width: 128, 
          height: 128, 
          child: onClicked != null ? InkWell(
            onTap: onClicked,
          ) : Container(),
        ),*/
        child: GestureDetector(
          onTap: onClicked,
          child: Text(key: Key('profilePic'), 'profilePic')
        )
      ),
    );
  }


  Widget buildEditIcon(Color color, VoidCallback onClicked) {
    return InkWell(
      onTap: onClicked,
      child: buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle (
          color: color,
          all: 8,
          child: Icon (
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }


  Widget buildCircle({required Widget child, required Color color, required double all,}) { 
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}