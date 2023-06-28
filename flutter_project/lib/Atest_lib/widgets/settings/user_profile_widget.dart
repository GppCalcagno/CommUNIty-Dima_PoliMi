import 'dart:io';
import 'package:dima_project/Atest_lib/services/notification_service.dart';
import 'package:dima_project/Atest_lib/services/database_service.dart';
import 'package:dima_project/Atest_lib/services/shared_preferences_service.dart';
import 'package:dima_project/Atest_lib/services/storage_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/layout_dimension.dart';
import 'package:dima_project/Atest_lib/widgets/settings/edit_field_widget.dart';
import 'package:dima_project/Atest_lib/widgets/settings/profile_image_widget.dart';
import 'package:dima_project/Atest_lib/widgets/settings/upper_gradient_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileWidget extends StatefulWidget {
  final UserModel currentUser;
  final bool switchValue;
  final bool enableNotification;
  const UserProfileWidget({super.key, required this.currentUser, required this.switchValue, required this.enableNotification});

  @override
  State<UserProfileWidget> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfileWidget> {
  DatabaseService dbService = DatabaseService();
  StorageService storage = StorageService();
  NotificationService notification = NotificationService();

  //String defaultUrl = 'https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png';
  String defaultUrl = 'test';
  late String imageUrl;
  late String username;
  late String firstName;
  late String lastName;

  final usernameController = TextEditingController();
  bool editUsername = false;
  final firstnameController = TextEditingController();
  bool editFirstname = false;
  final lastnameController = TextEditingController();
  bool editLastname = false;

  bool switchPosition = sharedPrefs.getPreference(SharedPreferencesService.notificationPositionKey);
  bool switchChat = sharedPrefs.getPreference(SharedPreferencesService.notificationChatKey);

  final GlobalKey<FormState> _form1Key = GlobalKey();
  final GlobalKey<FormState> _form2Key = GlobalKey();
  final GlobalKey<FormState> _form3Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    imageUrl = widget.currentUser.imageUrl;
    username = widget.currentUser.username;
    firstName = widget.currentUser.firstName ?? '';
    lastName = widget.currentUser.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          UpperGradientPicture(height: height, width: width),
    
          Transform.translate(
            offset: Offset(0.0, -(height * 0.02)),
            child: Container(
              height: 20,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
            ),
          ),
    
          SizedBox(
            width: width < limitWidth ? 600 : 950,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ProfileImageWidget(imageUrl: imageUrl, onClicked: _onTapShowBottomSheet),              
                      const SizedBox(height: 20),
                      buildName(username, widget.currentUser.email),
                      const SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          children: [
                            EditFieldWidget(
                                key: Key('usernameField'),
                                width: width,
                                controller: usernameController,
                                isUsername: true,
                                label: 'Username',
                                initialValue: username,
                                edit: editUsername,
                                editCallback: _updateUsername,
                                formKey: _form1Key),
                            const SizedBox(height: 30),
                            EditFieldWidget(
                                key: Key('firstNameField'),
                                width: width,
                                controller: firstnameController,
                                isUsername: false,
                                label: 'First Name',
                                initialValue: firstName,
                                edit: editFirstname,
                                editCallback: _updateFirstname,
                                formKey: _form2Key),
                            const SizedBox(height: 30),
                            EditFieldWidget(
                                key: Key('lastNameField'),
                                width: width,
                                controller: lastnameController,
                                isUsername: false,
                                label: 'Last Name',
                                initialValue: lastName,
                                edit: editLastname,
                                editCallback: _updateLastname,
                                formKey: _form3Key),
                            const SizedBox(height: 30),
                          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  key: Key('switchPosition'),
                                  value: widget.switchValue, //switchPosition,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (bool value) async {
                                    if (value) {
                                      if (await notification.requestNotificationPermission(widget.enableNotification)) {
                                        setState(() {
                                          switchPosition = true;
                                        });
                                        
                                        sharedPrefs.setPreference(SharedPreferencesService.notificationPositionKey, true);
                          
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Position notifications are enabled'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          switchPosition = false;
                                        });
                          
                                        sharedPrefs.setPreference(SharedPreferencesService.notificationPositionKey, false);
                              
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Cannot enable notifications, please check your settings'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                    else {
                                      setState(() {
                                        switchPosition = false;
                                      });
                          
                                      sharedPrefs.setPreference(SharedPreferencesService.notificationPositionKey, false);
                              
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Position notifications are disabled'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  }
                                ),
                                const SizedBox(width: 10),
                                Text('Position notifications', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                              
                            const SizedBox(height: 5),
                              
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  key: Key('switchChat'),
                                  value: widget.switchValue, //switchChat,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (bool value) async {
                                    if (value) {
                                      if (await notification.requestNotificationPermission(widget.enableNotification)) {
                                        setState(() {
                                          switchChat = true;
                                        });
                          
                                        sharedPrefs.setPreference(SharedPreferencesService.notificationChatKey, true);
                                        
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Chat notifications are enabled'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          switchChat = false;
                                        });
                          
                                        sharedPrefs.setPreference(SharedPreferencesService.notificationChatKey, false);
                          
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Cannot enable notifications, please check your settings'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                    else {
                                      setState(() {
                                        switchChat = false;
                                      });
                          
                                      sharedPrefs.setPreference(SharedPreferencesService.notificationChatKey, false);
                          
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Chat notifications are disabled'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text('Chat notifications', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (width > limitWidth) 
                const SizedBox(width: 50),
                if (width > limitWidth) 
                const SizedBox(
                  width: 300,
                  child: Image(
                    key: Key('settingsTabletImage'),
                    image: AssetImage("assets/settings.png"),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildName(String username, String email) => Column(
        children: [
          Text(
            key: Key('username'),
            username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            key: Key('email'),
            email,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  _onTapShowBottomSheet() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    key: Key('camera'),
                    leading: const Icon(Icons.camera_alt_rounded),
                    title: const Text('Take a picture'),
                    onTap: () async {
                      if (await _setProfilePic(ImageSource.camera)) {
                        if (context.mounted) {
                          Navigator.pop(context); // close bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Your profile picture has been updated')),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                    key: Key('gallery'),
                    leading: const Icon(Icons.photo_library_rounded),
                    title: const Text('Choose from gallery'),
                    onTap: () async {
                      if (await _setProfilePic(ImageSource.gallery)) {
                        if (context.mounted) {
                          Navigator.pop(context); // close bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Your profile picture has been updated')),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                    key: Key('avatar'),
                    leading: const Icon(Icons.person), title: const Text('Choose an avatar'), onTap: () => _onTapShowDialog(context)),
                  ListTile(
                    key: Key('delete'),
                    enabled: imageUrl != defaultUrl,
                    leading: const Icon(Icons.delete_rounded),
                    title: const Text('Delete profile picture'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              key: Key('deleteDialog'),
                              title: const Text('Delete profile picture'),
                              content: const Text('Are you sure you want to delete your profile picture?'),
                              actions: [
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    await _deleteProfilePic();

                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext); // close dialog
                                    }
                                    if (context.mounted) {
                                      Navigator.pop(context); // close bottom sheet
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Your profile picture has been deleted')),
                                      );
                                    }
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
                  ListTile(
                    key: Key('cancel'),
                    leading: const Icon(Icons.cancel_rounded),
                    title: const Text('Cancel'),
                    onTap: () => Navigator.pop(context),
                  )
                ],
              ),
            ],
          );
        },
        elevation: 10);
  }

  _onTapShowDialog(BuildContext bottomSheetContext) {
    double width = MediaQuery.of(context).size.width;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose an avatar'),
            content: FutureBuilder(
              future: storage.getAllAvatars(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: width < limitWidth ? 300 : 600,
                        height: width < limitWidth ? 300 : 400,
                        child: GridView.count(
                          crossAxisCount: width < limitWidth ? 3 : 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(snapshot.data!.length, (index) {
                            return InkWell(
                              /*child: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data![index].toString()),
                              ),*/
                              child: Text('Avatar$index'),
                              onTap: () async {
                                await _setAvatar(snapshot.data![index].toString());

                                if (context.mounted) {
                                  Navigator.pop(context); // close dialog
                                  Navigator.pop(bottomSheetContext); // close bottom sheet

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Your profile picture has been updated')),
                                  );
                                }
                              },
                            );
                          }),
                        ),
                      ),
                      TextButton(
                        key: Key('avatarCloseButton'),
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  );
                } else {
                  return Column(mainAxisSize: MainAxisSize.min, children: const [CircularProgressIndicator()]);
                }
              },
            ),
          );
        });
  }

  void _updateUsername(bool? edit) async {
    setState(() {
      editUsername = !editUsername;
    });
    if (edit != null && edit) {
      setState(() => username = usernameController.text);
      await dbService.updateUsername(usernameController.text);
    } else {
      //edit == null OR edit == false
      usernameController.text = username;
    }
  }

  void _updateFirstname(bool? edit) async {
    setState(() {
      editFirstname = !editFirstname;
    });

    if (edit != null && edit && firstnameController.text.isNotEmpty) {
      setState(() => firstName = firstnameController.text);
      await dbService.updateFirstName(firstnameController.text);
    } else if (edit != null && edit && firstnameController.text.isEmpty) {
      setState(() => firstName = firstnameController.text);
      await dbService.removeFirstName();
    } else {
      //edit == null OR edit == false
      firstnameController.text = firstName;
    }
  }

  void _updateLastname(bool? edit) async {
    setState(() => editLastname = !editLastname);

    if (edit != null && edit && lastnameController.text.isNotEmpty) {
      setState(() => lastName = lastnameController.text);
      await dbService.updateLastName(lastnameController.text);
    } else if (edit != null && edit && lastnameController.text.isEmpty) {
      setState(() => lastName = lastnameController.text);
      await dbService.removeLastName();
    } else {
      //edit == null OR edit == false
      lastnameController.text = lastName;
    }
  }

  Future<void> _setAvatar(String url) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    await dbService.updateProfilePic(url); // update imageUrl in db
    if (imageUrl.contains('profilepic')){
      await storage.removeProfilePic(); // remove old profile pic from storage, if any
    }

    setState(() => imageUrl = url);

    if (context.mounted) {
      Navigator.pop(context); // close dialog
    }
  }

  Future<bool> _setProfilePic(ImageSource imgSource) async {
    final image = await ImagePicker().pickImage(
      source: imgSource,
      imageQuality: 90,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image == null) return false;

    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
    }

    String? imgUrl = await storage.uploadProfilePic(File(image.path)); // upload new profile pic to storage and return url
    if (imgUrl == null) return false;

    await dbService.updateProfilePic(imgUrl); // update imageUrl in db

    setState(() => imageUrl = imgUrl);

    if (context.mounted) {
      Navigator.pop(context); // close dialog
    }
    return true;
  }

  Future<void> _deleteProfilePic() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    await dbService.updateProfilePic(defaultUrl); // update imageUrl in db
    if (imageUrl.contains('profilepic')){
      await storage.removeProfilePic(); // remove old profile pic from storage, if any
    }

    setState(() => imageUrl = defaultUrl);

    if (context.mounted) {
      Navigator.pop(context); // close dialog
    }
  }
}
