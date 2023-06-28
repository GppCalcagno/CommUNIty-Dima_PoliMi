import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/Atest_lib/widgets/network/map_tablet_widget.dart';
import 'package:dima_project/Atest_lib/widgets/network/position_list_widget.dart';
import 'package:dima_project/Atest_lib/widgets/network/share_position_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:dima_project/widgets/drawer.dart';
import 'package:geolocator/geolocator.dart';

class PositionTablet extends StatefulWidget {
  const PositionTablet({super.key});

  @override
  State<PositionTablet> createState() => PositionTabletState();
}

class PositionTabletState extends State<PositionTablet> {
  DatabaseService dbService = DatabaseService();
  late Future<List<UserModel>> userPositionList;
  late Future<List<CourseModel>> userCourses;

  Position? currentPosition;
  String? currentAddress;

  PositionModel? userPosition;
  String? username;

  @override
  void initState() {
    super.initState();
    userPositionList = dbService.getPositionList(null);
    userCourses = dbService.getUserCourses(false);
    //debugPrint("position tablet INIT");
  }

  @override
  void dispose() {
    //debugPrint("position tablet DISPOSE");
    super.dispose();
  }

  callback(PositionModel position, String user) {
    setState(() {
      userPosition = position;
      username = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [

            // left view
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Filter by course', style: TextStyle(color: Colors.deepPurple[400], fontSize: 15)),
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
                                          _updateList('empty');
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
                        )
                      ),
                    ],
                  ),
            
                  Expanded(
                    child: FutureBuilder(
                      future: userPositionList,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Icon(Icons.error));
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          return PositionListWidget(
                            userPositionList: snapshot.data!,
                            callback: callback,
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }
                    ),
                  ),
                ],
              ),
            ),
        
            // right view
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 700,
                child: MapTabletWidget(
                  userPosition: userPosition,
                  username: username,
                )
              ),
            )
          ],
        ),
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
    //debugPrint('UPDATE position list tablet');
  }

   _openShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Share your position", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.deepPurple[400])),
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
                  isTablet: true,
                );
              } else {
                return Column(mainAxisSize: MainAxisSize.min, children: const [CircularProgressIndicator()]);
              }
            }
          )
        );
      }
    );
  }

  // Utility functions for location
  Future<bool> _handleLocationPermission() async {
    setState(() {
      currentPosition = Position(latitude: 0, longitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
      currentAddress = '';
    });
    return true;
    /*showDialog(
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
    }*/
  }

  /*_getCurrentPosition() async {
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
        currentAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {});
  }*/
}
