import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/course_model.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/classes/message_model.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/classes/review_model.dart';
import 'package:dima_project/services/shared_preferences_service.dart';
import 'package:dima_project/services/storage_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  /* *** USERS *** */

  //Create a user in the database,used after the registration or the first login with google
  Future<void> createUser(String username, String email, String imageUrl) async {
    await _db.collection('users').doc(_uid).set({
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
    }, SetOptions(merge: true));
  }

  // Get the current user from the database
  Future<UserModel> getCurrentUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('users').doc(_uid).get();
    UserModel user = UserModel.fromDocumentSnapshot(snapshot);
    return user;
  }

  // Update the username of the current user: used in the settings page
  Future<bool> updateUsername(String username) async {
    try {
      await _db.collection('users').doc(_uid).set({'username': username}, SetOptions(merge: true));
      // update the username of the current user also in the authentication
      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update the first name of the current user: used in the settings page
  Future<bool> updateFirstName(String firstName) async {
    try {
      await _db.collection('users').doc(_uid).set({'first_name': firstName}, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update the last name of the current user: used in the settings page
  Future<bool> updateLastName(String lastName) async {
    try {
      await _db.collection('users').doc(_uid).set({'last_name': lastName}, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove the first name of the current user: used in the settings page
  Future<bool> removeFirstName() async {
    try {
      await _db.collection('users').doc(_uid).set({'first_name': FieldValue.delete()}, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove the last name of the current user: used in the settings page
  Future<bool> removeLastName() async {
    try {
      await _db.collection('users').doc(_uid).set({'last_name': FieldValue.delete()}, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update the profile picture of the current user: used in the settings page
  Future<bool> updateProfilePic(String imageUrl) async {
    try {
      await _db.collection('users').doc(_uid).set({'imageUrl': imageUrl}, SetOptions(merge: true));
      // update the profile picture of the current user also in the authentication
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Add user's token to the database for receiving position notifications
  void addPositionToken(String token) async {
    try {
      await _db.collection('positionTokens').doc('list').set({
        '/': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Remove user's token from the database
  void removePositionToken(String token) {
    try {
      _db.collection('positionTokens').doc('list').set({
        '/': FieldValue.arrayRemove([token])
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get all the tokens of the users that want to receive position notifications
  Future<List<String>> getPositionTokens() async {
    List<String> tokens = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('positionTokens').doc('list').get();
      if (snapshot.exists) {
        List<dynamic> tokenList = snapshot.data()!['/'];
        for (var token in tokenList) {
          tokens.add(token);
        }
      }
      return tokens;
    } catch (e) {
      debugPrint(e.toString());
      return tokens;
    }
  }

  // Add user's token to the database for receiving chat notifications
  void addChatToken(String token, String group) async {
    try {
      await _db.collection('chatTokens').doc(group).set({
        'list': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Remove user's token from the database
  void removeChatToken(String token, String group) {
    try {
      _db.collection('chatTokens').doc(group).set({
        'list': FieldValue.arrayRemove([token])
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get all the tokens of the users that want to receive chat notifications
  Future<List<String>> getChatTokens(String group) async {
    List<String> tokens = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('chatTokens').doc(group).get();
      if (snapshot.exists) {
        List<dynamic> tokenList = snapshot.data()!['list'];
        for (var token in tokenList) {
          tokens.add(token);
        }
      }
      return tokens;
    } catch (e) {
      debugPrint(e.toString());
      return tokens;
    }
  }


  /* *** GROUP CHAT *** */

  // Add a member to a group: called in addUserGroup
  Future<void> addGroupMember(String groupId, String userId) async {
    DocumentReference userRef = FirebaseFirestore.instance.doc('users/$userId');
    await _db.collection('groups').doc(groupId).set({
      'members': FieldValue.arrayUnion([userRef])
    }, SetOptions(merge: true));
  }

  // Remove a member from a group: called in removeUserGroup
  Future<void> removeGroupMember(String groupId, String userId) async {
    DocumentReference userRef = FirebaseFirestore.instance.doc('users/$userId');
    await _db.collection('groups').doc(groupId).set({
      'members': FieldValue.arrayRemove([userRef])
    }, SetOptions(merge: true));
  }

  // Add a group to the group list of the current user: called in addUserCourse
  Future<void> addUserGroup(String groupId) async {
    DocumentReference groupRef = FirebaseFirestore.instance.doc('groups/$groupId');
    await _db.collection('users').doc(_uid).collection('groups').doc('list').set({
      '/': FieldValue.arrayUnion([groupRef])
    }, SetOptions(merge: true));

    await addGroupMember(groupId, _uid); // add the current user to the group's members

    if(sharedPrefs.getPreference(SharedPreferencesService.notificationChatKey)) {
      Future<String> token = FirebaseMessaging.instance.getToken().then((value) => value.toString());
      addChatToken(await token, groupId); // add the current user's token to the group's chat tokens
    }
  }

  // Remove a group from the group list of the current user: called in removeUserCourse
  Future<void> removeUserGroup(String groupId) async {
    DocumentReference groupRef = FirebaseFirestore.instance.doc('groups/$groupId');
    await _db.collection('users').doc(_uid).collection('groups').doc('list').set({
      '/': FieldValue.arrayRemove([groupRef])
    }, SetOptions(merge: true));

    await removeGroupMember(groupId, _uid); // remove the current user from the group's members

    if(sharedPrefs.getPreference(SharedPreferencesService.notificationChatKey)) {
      Future<String> token = FirebaseMessaging.instance.getToken().then((value) => value.toString());
      removeChatToken(await token, groupId); // remove the current user's token from the group's chat tokens
    }
  }

  // Get the list of groups of the current user
  Future<List<GroupChatModel>> getUserGroups() async {
    List<GroupChatModel> groups = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('users').doc(_uid).collection('groups').doc('list').get();
    if (snapshot.exists) {
      List<dynamic> groupsRefs = snapshot.data()!['/'];
      for (var groupRef in groupsRefs) {
        DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await groupRef.get() as DocumentSnapshot<Map<String, dynamic>>;
        groups.add(GroupChatModel.fromDocumentSnapshot(groupSnapshot));
      }
    }
    return groups;
  }

  Future<List<String>> getUserGroupIds() {
    return _db.collection('users').doc(_uid).collection('groups').doc('list').get().then((snapshot) {
      if (snapshot.exists) {
        List<dynamic> groupsRefs = snapshot.data()!['/'];
        List<String> groupIds = [];
        for (var groupRef in groupsRefs) {
          groupIds.add(groupRef.id);
        }
        return groupIds;
      } else {
        return [];
      }
    });
  }

  // Get the list of groups of the current user - STREAM VERSION
  /*Stream<List<GroupChatModel>> streamUserGroups(List<String> groupIds) async* {
      var groupsCollection = _db.collection('groups').where(FieldPath.documentId, whereIn: groupIds);

      await for (QuerySnapshot<Map<String, dynamic>> snapshot in groupsCollection.snapshots()) {
        if (snapshot.size > 0) {
          List<GroupChatModel> groups = [];
          for (var groupSnapshot in snapshot.docs) {
            groups.add(GroupChatModel.fromDocumentSnapshot(groupSnapshot));
          }
          yield groups;
        }
      }
    }*/

  Stream<List<GroupChatModel>> streamUserGroups(List<String> groupIds) async* {
    final groupsList = <GroupChatModel>[];

    for (var groupId in groupIds) {
      final snapshot = await _db.collection('groups').doc(groupId).get();
      if (snapshot.exists) {
        groupsList.add(GroupChatModel.fromDocumentSnapshot(snapshot));
      }
    }

    yield groupsList; // yield the initial list of groups

    final snapshots = _db.collection('groups').snapshots(); // listen to changes in the groups collection

    await for (var snapshot in snapshots) {
      for (var change in snapshot.docChanges) {
        final groupId = change.doc.id;
        final group = GroupChatModel.fromDocumentSnapshot(change.doc);

        if (groupIds.contains(groupId)) {
          if (change.type == DocumentChangeType.removed) {
            groupsList.removeWhere((g) => g.groupId == groupId);
          } else { // DocumentChangeType.added or DocumentChangeType.modified
            final existingGroupIndex = groupsList.indexWhere((g) => g.groupId == groupId);
            if (existingGroupIndex != -1) {
              groupsList[existingGroupIndex] = group;
            } else {
              groupsList.add(group);
            }
          }

          yield groupsList;
        }
      }
    }
  }

   // Get the sender data of a message: called in getGroupMessages
  Future<UserModel> getMessageSender(MessageModel msg) async {
    DocumentReference ref = msg.sender;
    return await _db.collection('users').doc(ref.id).get().then((snapshot) => UserModel.fromDocumentSnapshot(snapshot));
  }

  // Get the list of messages in a group chat
  Future<List<MessageModel>> getGroupMessages(String groupId) async {
    List<MessageModel> messages = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('groups').doc(groupId).collection('messages').orderBy('timestamp', descending: true).get();
    if (snapshot.size > 0) {
      for (var messageSnapshot in snapshot.docs) {
        MessageModel msg = MessageModel.fromDocumentSnapshot(messageSnapshot);
        msg.senderData = await getMessageSender(msg); // get the sender data
        messages.add(msg);
      }
    }
    return messages;
  }

  // Current user sending a message in a group chat
  Future<bool> sendMessage(String groupId, MessageModel msg) async {
    try {
      await _db.collection('groups').doc(groupId).collection('messages').add(msg.toMap(_uid));

      await _db.collection('groups').doc(groupId).set({'lastMessage': msg.message}, SetOptions(merge: true));
      await _db.collection('groups').doc(groupId).set({'lastMessageSender': msg.senderData!.username}, SetOptions(merge: true));
      await _db.collection('groups').doc(groupId).set({'lastMessageTimestamp': msg.timestamp}, SetOptions(merge: true));
      
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Get the list of members in a group chat
  Future<List<UserModel>> getGroupMembers(String groupId) async {
    List<UserModel> members = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('groups').doc(groupId).get();
    if (snapshot.exists) {
      List<dynamic> membersRefs = snapshot.data()!['members'];
      for (var memberRef in membersRefs) {
        DocumentSnapshot<Map<String, dynamic>> memberSnapshot = await memberRef.get() as DocumentSnapshot<Map<String, dynamic>>;
        members.add(UserModel.fromDocumentSnapshot(memberSnapshot));
      }
    }
    return members;
  }

  // Get the last message in a group chat - STREAM VERSION
  Stream<MessageModel> streamLastMessage(String groupId) async* {
    var messagesCollection = _db.collection('groups').doc(groupId).collection('messages').orderBy('timestamp', descending: true).limit(1);

    await for (QuerySnapshot<Map<String, dynamic>> snapshot in messagesCollection.snapshots()) {
      if (snapshot.size > 0) {
        MessageModel msg = MessageModel.fromDocumentSnapshot(snapshot.docs[0]);
        msg.senderData = await getMessageSender(msg); // get the sender data
        yield msg;
      } 
    }
  }


  /* *** POSITION *** */

  // Add the position of the current user: used in the network page
  Future<bool> addCurrentPosition(PositionModel position) async {
    try {
      await _db.collection('users').doc(_uid).set({'position': position.toMap()}, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Remove the position of the current user: used in the network page
  Future<bool> removeCurrentPosition() async {
    try {
      await _db.collection('users').doc(_uid).set({'position': FieldValue.delete()}, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // Get the list of users with their position (showing only current day) ordered by timestamp: used in the network page
  Future<List<UserModel>> getPositionList(String? courseName) async {
    List<UserModel> users = [];
    QuerySnapshot<Map<String, dynamic>> snapshot;

    var startOfToday = DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second));
    //debugPrint(startOfToday.toString());

    if (courseName != null) {
      snapshot = await _db.collection('users').where('position.course', isEqualTo: courseName).where('position.timestamp', isGreaterThan: startOfToday).orderBy('position.timestamp', descending: true).get();
    } else {
      snapshot = await _db.collection('users').where('position.timestamp', isGreaterThan: startOfToday).orderBy('position.timestamp', descending: true).get();
    }
    for (var user in snapshot.docs) {
      if (user.id != _uid) {
        users.add(UserModel.fromDocumentSnapshot(user));
      } else {
        users.insert(0, UserModel.fromDocumentSnapshot(user)); // insert the current user at the beginning of the list
      }
    }
    return users;
  }

  /* *** COURSES *** */

  // Get the list of courses of the current user
  Future<void> addUserCourse(String courseId) async {
    DocumentReference courseRef = FirebaseFirestore.instance.doc('courses/$courseId');
    await _db.collection('users').doc(_uid).collection('courses').doc('list').set({
      '/': FieldValue.arrayUnion([courseRef])
    }, SetOptions(merge: true));

    await addUserGroup(courseId); // add the group of the course to the user's groups list
  }

  Future<bool> removeUserCourse(String courseId) async {
    try {
      DocumentReference courseRef = FirebaseFirestore.instance.doc('courses/$courseId');
      await _db.collection('users').doc(_uid).collection('courses').doc('list').set({
        '/': FieldValue.arrayRemove([courseRef])
      }, SetOptions(merge: true));

      await removeUserGroup(courseId); // remove the group of the course from the user's groups list
    } catch (e) {
      return false;
    }
    return true;
  }

  // Get the list of courses of the current user: used in the course and the network page
  Future<List<CourseModel>> getUserCourses() async {
    List<CourseModel> courses = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('users').doc(_uid).collection('courses').doc('list').get();
    if (snapshot.exists) {
      List<dynamic> coursesRefs = snapshot.data()!['/'];
      for (var courseRef in coursesRefs) {
        DocumentSnapshot<Map<String, dynamic>> courseSnapshot = await courseRef.get() as DocumentSnapshot<Map<String, dynamic>>;
        courses.add(CourseModel.fromDocumentSnapshot(courseSnapshot));
      }
    }
    return courses;
  }

  // Get the list of all the courses: used in the course page
  Future<List<CourseModel>> getAllCourse() async {
    List<CourseModel> courses = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('courses').get();
    for (var course in snapshot.docs) {
      courses.add(CourseModel.fromDocumentSnapshot(course));
    }
    return courses;
  }

  /* *** REVIEW *** */

  Future<List<ReviewModel>> getReviews(CourseModel course, String order, int evaluation) async {
    List<ReviewModel> reviews = [];
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (evaluation == 0) {
      snapshot = await _db.collection('courses').doc(course.courseId).collection('reviews').orderBy('timestamp', descending: order == "Newer").get();
    } else {
      snapshot = await _db
          .collection('courses')
          .doc(course.courseId)
          .collection('reviews')
          .where('evaluation', isEqualTo: evaluation)
          .orderBy('timestamp', descending: order == "Newer")
          .get();
    }

    for (var review in snapshot.docs) {
      UserModel author = UserModel.fromDocumentSnapshot(await review.data()['author'].get());

      reviews.add(ReviewModel.fromMap(review.data(), author));
    }

    return reviews;
  }

  //load Review in firestore
  Future<bool> addReview(CourseModel course, String name, int evaluation, String? description, Timestamp ts, UserModel author) async {
    try {
      //generate a random id for the review
      DocumentReference documentReference = _db.collection('courses').doc(course.courseId).collection('reviews').doc();
      ReviewModel reviewModel =
          ReviewModel(id: documentReference.id, name: name, evaluation: evaluation, description: description, timestamp: ts, author: author);
      await _db.collection('courses').doc(course.courseId).collection('reviews').doc(reviewModel.id).set(reviewModel.toMap());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  //delete Review in firestore
  Future<bool> deleteReview(CourseModel course, ReviewModel review) async {
    try {
      await _db.collection('courses').doc(course.courseId).collection('reviews').doc(review.id).delete();
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  /* *** NOTES *** */

  Future<bool> addNotes(
    CourseModel course,
    String name,
    bool isShared,
    List<PlatformFile>? attachment,
    String? description,
    Timestamp timestamp,
    UserModel author,
  ) async {
    try {
      //generate a random id for the note
      DocumentReference reference = _db.collection('courses').doc(course.courseId).collection('notes').doc();

      //upload the attachments to the storage
      await StorageService().uploadNoteFile(attachment, course.courseId, reference.id);

      NoteModel notesModel = NoteModel(
          id: reference.id,
          name: name,
          isShared: isShared,
          description: description,
          timestamp: timestamp,
          author: author,
          courseId: course.courseId);

      //Upload the note to the firestore
      await _db.collection('courses').doc(course.courseId).collection('notes').doc(notesModel.id).set(notesModel.toMap());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  Future<List<NoteModel>> getNotes(CourseModel course, String order, String preferences) async {
    List<NoteModel> notes = [];
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (preferences == 'My Notes') {
      snapshot = await _db
          .collection('courses')
          .doc(course.courseId)
          .collection('notes')
          .where('author', isEqualTo: FirebaseFirestore.instance.doc("users/${_uid}"))
          .orderBy('timestamp', descending: order == "Newer")
          .get();
    } else if (preferences == 'My Private Notes') {
      snapshot = await _db
          .collection('courses')
          .doc(course.courseId)
          .collection('notes')
          .where('author', isEqualTo: FirebaseFirestore.instance.doc("users/${_uid}"))
          .where('isShared', isEqualTo: false)
          .orderBy('timestamp', descending: order == "Newer")
          .get();
    } else if (preferences == 'My Public Notes') {
      snapshot = await _db
          .collection('courses')
          .doc(course.courseId)
          .collection('notes')
          .where('author', isEqualTo: FirebaseFirestore.instance.doc("users/${_uid}"))
          .where('isShared', isEqualTo: true)
          .orderBy('timestamp', descending: order == "Newer")
          .get();
    } else {
      snapshot = await _db
          .collection('courses')
          .doc(course.courseId)
          .collection('notes')
          .where('isShared', isEqualTo: true)
          .orderBy('timestamp', descending: order == "Newer")
          .get();
    }

    for (var x in snapshot.docs) {
      UserModel author = UserModel.fromDocumentSnapshot(await x.data()['author'].get());

      NoteModel note = NoteModel.fromMap(x.data(), author);
      note.attachmentUrls = await StorageService().getNoteAttachments(course.courseId, note.id);

      notes.add(note);
    }

    return notes;
  }

  Future<bool> deleteNote(NoteModel note) async {
    try {
      await _db.collection('courses').doc(note.courseId).collection('notes').doc(note.id).delete();
      await StorageService().deleteAllNoteAttachments(note.courseId, note.id);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> UpdateNote(NoteModel note, List<String> toDeleteAttachments, List<PlatformFile>? toUploadAttachments) async {
    try {
      await _db.collection('courses').doc(note.courseId).collection('notes').doc(note.id).update(note.toMap());
      await StorageService().deleteNoteAttachment(note.courseId, note.id, toDeleteAttachments);
      await StorageService().uploadNoteFile(toUploadAttachments, note.courseId, note.id);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }
}
