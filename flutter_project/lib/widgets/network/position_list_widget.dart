import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:dima_project/widgets/network/position_el_inlist_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PositionListWidget extends StatefulWidget {
  final List<UserModel> userPositionList;
  final Function? callback;

  const PositionListWidget({super.key, required this.userPositionList, this.callback});

  @override
  State<PositionListWidget> createState() => PositionListState();
}

class PositionListState extends State<PositionListWidget> {
  DatabaseService dbService = DatabaseService();
  late List<UserModel> positionList;

  @override
  void initState() {
    super.initState();
    positionList = widget.userPositionList;
    debugPrint("position list widget INIT");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('position list widget DISPOSE');
  }

  _refreshList() async {
    var temp = await Future.delayed(const Duration(milliseconds: 500), () => dbService.getPositionList(null));
    setState(() => positionList = temp);
    debugPrint('REFRESH position list');
  }

  Future<bool> _deletePosition() async {
    if (await dbService.removeCurrentPosition()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshList();
              },
              child: positionList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: positionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel user = positionList[index];

                        //if the current user is the owner of the position, allow to delete it
                        if (user.uid == FirebaseAuth.instance.currentUser!.uid) {
                          return Dismissible(
                              key: ValueKey<int>(index), // Set a unique key for the item
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete your position", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                                      content: const Text("Are you sure you want to delete your position?", style: TextStyle(fontSize: 16)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("Delete", style: TextStyle(fontSize: 16)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) async {
                                if (await _deletePosition()) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Your position has been deleted')),
                                    );
                                  }
                                  setState(() {
                                    positionList.removeAt(index);
                                  });
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error deleting your position, please try again later.')),
                                    );
                                  }
                                }
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('  YOUR SHARED POSITION',
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.deepPurple[400])),
                                      ],
                                    ),
                                    PositionListElementWidget(user: user, color: Color.fromARGB(255, 134, 97, 236).withOpacity(0.8)),
                                    Divider(color: const Color(0xf4DADADA)),
                                  ])));
                        } else {
                          return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                InkWell(
                                    onTap: () {
                                      PositionModel pos = PositionModel(
                                          latitude: user.position!.latitude,
                                          longitude: user.position!.longitude,
                                          timestamp: user.position!.timestamp,
                                          description: user.position!.description ?? "",
                                          courseName: user.position!.courseName ?? "");

                                      if (widget.callback == null) {
                                        context.push("/map", extra: pos);
                                      } else {
                                        if (user.firstName != null && user.lastName != null) {
                                          widget.callback!(pos, '${user.firstName} ${user.lastName}');
                                        } else {
                                          widget.callback!(pos, user.username);
                                        }
                                      }
                                    },
                                    child: PositionListElementWidget(user: user))
                              ]));
                        }
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                    )
                  : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/noPositionFound.png',
                            width: 200,
                            height: 200,
                          ),
                          Text('No results found', style: TextStyle(color: Colors.grey[600], fontSize: 16))
                        ]
                      )
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}
