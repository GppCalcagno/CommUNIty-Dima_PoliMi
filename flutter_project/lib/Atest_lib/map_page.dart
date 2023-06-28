import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/Atest_lib/widgets/network/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  final PositionModel userPosition;
  const MapScreen({super.key, required this.userPosition});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Position? currentPosition;
  
  @override
  void initState() {
    super.initState();
    //debugPrint('map screen INIT');
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Check on the map'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8),
      ),
      body: MapWidget(userPosition: widget.userPosition),
    );
  }


  
}