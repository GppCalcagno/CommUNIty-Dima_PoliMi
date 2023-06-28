import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:dima_project/widgets/network/share_position_form_widget.dart';
import 'package:dima_project/widgets/network/upper_gradient_picture_position.dart';
import 'package:flutter/material.dart';
import 'package:dima_project/widgets/network/position_list_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PositionList extends StatefulWidget {
  const PositionList({super.key});

  @override
  State<PositionList> createState() => PositionListState();
}

class PositionListState extends State<PositionList> {
  DatabaseService dbService = DatabaseService();
  late Future<List<UserModel>> userPositionList;
  late Future<List<CourseModel>> userCourses;

  Position? currentPosition;
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    userPositionList = dbService.getPositionList(null);
    userCourses = dbService.getUserCourses();
    debugPrint("position list page INIT");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('position list page DISPOSE');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
      ),
      body: Column(
        children: [
          UpperGradientPicturePosition(height: height, width: width),
          Transform.translate(
            offset: Offset(0.0, -(height * 0.025)),
            child: Container(
                height: 48,
                width: width,
                //padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 28, 28, 28) : Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Filter by course', style: TextStyle(color: Colors.deepPurple[400], fontSize: 17)),
                    Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: PopupMenuButton<String>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
                          tooltip: "Filter by course",
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: FutureBuilder(
                                future: userCourses,
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Error');
                                  } else if (!snapshot.hasData) {
                                    return const Text('Loading...');
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text('COURSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepPurple[400])),
                                      const SizedBox(height: 5),
                                      Divider(),
                                      ListTile(
                                        title: const Text('None'),
                                        contentPadding: EdgeInsets.all(3.0),
                                        onTap: () {
                                          _updateList(null);
                                          Navigator.pop(context); //close popup menu
                                        },
                                      ),
                                      ...snapshot.data!.map((entry) {
                                        return ListTile(
                                          title: Text(entry.name),
                                          contentPadding: EdgeInsets.all(3.0),
                                          onTap: () {
                                            _updateList(entry.name);
                                            Navigator.pop(context); //close popup menu
                                          },
                                        );
                                      }).toList(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                          icon: Icon(Icons.filter_alt_outlined, color: Colors.deepPurple[400]),
                        )),
                    SizedBox(width: 15),
                  ],
                )),
          ),
          Expanded(
            child: FutureBuilder(
                future: userPositionList,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return PositionListWidget(userPositionList: snapshot.data!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                _handleLocationPermission().then((value) {
                  if (value) {
                    _openShareDialog();
                  }
                }),
              },
          tooltip: 'Share your position',
          child: const Icon(Icons.add_location_alt_outlined)),
      drawer: const DrawerForNavigation(),
    );
  }

  _updateList(String? courseName) async {
    setState(() {
      userPositionList = Future.delayed(const Duration(milliseconds: 500), () => dbService.getPositionList(courseName)); //delay used for testing
    });
    debugPrint('UPDATE position list');
  }

  _openShareDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Share your position", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 134, 97, 236).withOpacity(1))),
              content: FutureBuilder(
                  future: userCourses,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Icon(Icons.error));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return SharePositionForm(
                        userCourses: snapshot.data!,
                        currentPosition: currentPosition!,
                        currentAddress: currentAddress!,
                        updateListFunct: _updateList,
                        isTablet: false,
                      );
                    } else {
                      return Column(mainAxisSize: MainAxisSize.min, children: const [CircularProgressIndicator()]);
                    }
                  }));
        });
  }

  // Utility functions for location
  Future<bool> _handleLocationPermission() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      }
      if (context.mounted) {
        Navigator.pop(context); //close the dialog
      }
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        }
        if (context.mounted) {
          Navigator.pop(context); //close the dialog
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      if (context.mounted) {
        Navigator.pop(context); //close the dialog
      }
      return false;
    }

    try {
      await _getCurrentPosition(); //set currentPosition
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error getting your position, please try again later.')));
      }
      return false;
    }

    if (context.mounted) {
      Navigator.pop(context); //close the dialog
    }

    return true;
  }

  _getCurrentPosition() async {
    // medium accuracy results in a faster response time at the cost of less accurate location data (no use of GPS)
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).then((Position position) async {
      setState(() => currentPosition = position);
      await _getAddressFromLatLng(position);
    }).catchError((e) {});
  }

  _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        //currentAddress = '${place.country}, ${place.administrativeArea}, ${place.street}, ${place.postalCode}';
        currentAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {});
  }
}
