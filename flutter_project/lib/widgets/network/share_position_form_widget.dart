import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/services/notification_service.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SharePositionForm extends StatefulWidget {
  final List<CourseModel> userCourses;
  final Position currentPosition;
  final String currentAddress;
  final Function? updateListFunct;
  final bool isTablet;

  const SharePositionForm({required this.userCourses, this.updateListFunct, super.key, required this.currentPosition, required this.currentAddress, required this.isTablet});

  @override
  State<SharePositionForm> createState() => SharePositionFormState();
}

class SharePositionFormState extends State<SharePositionForm> {
  DatabaseService dbService = DatabaseService();
  
  final _formKey = GlobalKey<FormState>();
  CourseModel? dropdownValue;
  final textController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    //debugPrint("share position form INIT");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
    //debugPrint('share position form DISPOSE');
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isTablet ? 800 : 300,
      height: widget.isTablet ? 400 : 550,
      child: widget.isTablet ? 
        // TABLET VERSION
        tabletRow(context) 
        // MOBILE VERSION
        : mobileColumn(context)
    );
  }

  Row tabletRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 350,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'YOU ARE HERE:\n${widget.currentAddress}',
                  //'YOU ARE HERE:\n ajhsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahjshajshajhsjahsjahsjahsjahsjahsjahsjahsjahsjh',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              //SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/sharePosition.png"),
                    fit: BoxFit.cover
                  ),
                ),
                height: 300,
              ),
            ]
          ),
        ),
        VerticalDivider(color: Theme.of(context).brightness == Brightness.light ? const Color(0xf4DADADA) : Colors.grey[800]),
        SizedBox(
          width: 350,
          child: shareForm(context),
        )
      ],
    );
  }


  Column mobileColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Divider(color: const Color(0xf4DADADA)),
        Row(
          children: [
            Flexible(
              child: Text(
                'YOU ARE HERE:\n${widget.currentAddress}',
                //'YOU ARE HERE:\n ajhsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahsjahjshajshajhsjahsjahsjahsjahsjahsjahsjahsjahsjh',
                style: const TextStyle(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/sharePosition.png"),
              fit: BoxFit.contain
            ),
          ),
          height: 140,
        ),
        Divider(color: const Color(0xf4DADADA)),
        Flexible(
          child: SingleChildScrollView(
            child: shareForm(context),
          ),
        ),
      ]
    );
  }


  Form shareForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height:30),
          TextFormField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),              
              ),
              hintText: '(Optional)',
              labelText: "Description",
              suffixIcon: Icon(Icons.short_text),
              labelStyle: TextStyle(
                color: Colors.deepPurple[400],
                fontWeight: FontWeight.bold,
              )
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.length > 30) {
                return 'Max 30 characters';
              }
              return null;
            },
          ),
          const SizedBox(height:30),
          DropdownButtonFormField<CourseModel>(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            menuMaxHeight: 200,
            isExpanded: true,
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),           
            items: [ 
              const DropdownMenuItem<CourseModel>(                      
                value: null,
                child: Text('None'),                        
              ),
              ...widget.userCourses.map<DropdownMenuItem<CourseModel>>((CourseModel course) {
              return DropdownMenuItem<CourseModel>(
                value: course,
                child: Text(
                  course.name,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            })].toList(),
            onChanged: (CourseModel? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),                              
              ),
              labelText: "Course",
              labelStyle: TextStyle(
                color: Colors.deepPurple[400],
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          const SizedBox(height:30),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()){
                if (await _saveCurrentPosition(widget.currentPosition, textController.text, dropdownValue?.name)) {
                  _sendPushNotifications();                        
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your current position has been saved')),
                    );                      
                    Navigator.pop(context); //close the share dialog
                  }
                  
                  widget.updateListFunct!(null); //trigger a refresh of the list page by calling the _updateList function
                
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('An error occurred while saving your position, please try again later')),
                    );
                  }
                }
              }
            },
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.deepPurple[400]),
              elevation: MaterialStateProperty.all(3),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enableFeedback: true,
              minimumSize: MaterialStateProperty.all(Size(100, 50)),
            ),
            child: const Text('SHARE')
          ),
        ],
      ),
    );
  }


  Future<bool> _saveCurrentPosition(Position pos, String description, String? course) async {
    Timestamp ts = Timestamp.now();
      
    PositionModel newPos = PositionModel(
      latitude: pos.latitude.toString(),
      longitude: pos.longitude.toString(),
      description: description,
      courseName: course,
      timestamp: ts,
    );

    if (await dbService.addCurrentPosition(newPos)) {
      return true;
    } else {
      return false;
    }
  }


  void _sendPushNotifications() async {
    try {
      List<String> tokens = await dbService.getPositionTokens();
      String username = await dbService.getCurrentUser().then((value) => value.username);
      Map<String, dynamic> data = {
        'title': 'New update!',
        'body': '$username has shared his position',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      };
      tokens.remove(await FirebaseMessaging.instance.getToken());
      if (tokens.isNotEmpty) {
        NotificationService().sendPushNotification(tokens, 'New update!', '$username has shared his position', data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
