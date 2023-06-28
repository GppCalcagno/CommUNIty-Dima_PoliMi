import 'package:dima_project/classes/user_model.dart';
import 'package:flutter/material.dart';

class PositionListElementWidget extends StatelessWidget {
  const PositionListElementWidget({
    super.key,
    required this.user,
    this.color,
  });

  final UserModel user; //user.position EXISTS for sure because the query in getPositionList retrieves only users having the field position, who are then passed to this widget
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
            child: CircleAvatar(              
              foregroundImage: NetworkImage(user.imageUrl),
              radius: 30,
            )
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 15, 20, 0),
                  child: Text(
                    (user.firstName != null && user.lastName != null) ? '${user.firstName!} ${user.lastName!}' : user.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.position!.courseName == null ? 'No course' : 'COURSE: ${user.position!.courseName!}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.position!.description!.isEmpty ? 'No additional notes' : 'NOTES: ${user.position!.description!}',
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Last update:  ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                      Text('${user.position!.timestamp.toDate().year.toString()}-${user.position!.timestamp.toDate().month.toString().padLeft(2,'0')}-${user.position!.timestamp.toDate().day.toString().padLeft(2,'0')} ${user.position!.timestamp.toDate().hour.toString().padLeft(2,'0')}:${user.position!.timestamp.toDate().minute.toString().padLeft(2,'0')}', 
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}