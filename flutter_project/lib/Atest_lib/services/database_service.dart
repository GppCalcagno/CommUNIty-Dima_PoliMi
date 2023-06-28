import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/Atest_lib/classes/course_model.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/Atest_lib/classes/message_model.dart';
import 'package:dima_project/classes/note_model.dart';
import 'package:dima_project/classes/position_model.dart';
import 'package:dima_project/classes/review_model.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:file_picker/file_picker.dart';

class DatabaseService {
  final String _uid = "0123456789";

  String getUid() {
    return _uid;
  }

  /* *** USERS *** */

  //Create a user in the database,used after the registration or the first login with google
  Future<void> createUser(String username, String email, String imageUrl) async {}

  // Get the current user from the database
  Future<UserModel> getCurrentUser() async {
    UserModel user = UserModel(
      uid: _uid,
      username: "testUsername",
      email: "testEmail@mail.it",
      imageUrl: "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png",
    );

    return user;
  }

  // Update the username of the current user: used in the settings page
  Future<bool> updateUsername(String username) async {
    return true;
  }

  // Update the first name of the current user: used in the settings page
  Future<bool> updateFirstName(String firstName) async {
    return true;
  }

  // Update the last name of the current user: used in the settings page
  Future<bool> updateLastName(String lastName) async {
    return true;
  }

  // Remove the first name of the current user: used in the settings page
  Future<bool> removeFirstName() async {
    return true;
  }

  // Remove the last name of the current user: used in the settings page
  Future<bool> removeLastName() async {
    return true;
  }

  // Update the profile picture of the current user: used in the settings page
  Future<bool> updateProfilePic(String imageUrl) async {
    return true;
  }

  /* *** GROUP CHAT *** */

  Future<List<String>> getUserGroupIds(bool isEmpty) async {
    List<String> groupIds = [];
    groupIds.add('groupId1');
    groupIds.add('groupId2');
    groupIds.add('groupId3');

    return isEmpty ? [] : groupIds;
  }

  Stream<List<GroupChatModel>> streamUserGroups(List<String> groupIds) async* {
    final groupsList = <GroupChatModel>[];
    GroupChatModel group1 = GroupChatModel(
      icon: 'icon1',
      groupId: 'groupId1',
      name: "name1",
      lastMessage: 'lastMessage1',
      lastMessageTimestamp: Timestamp.now(),
      lastMessageSender: 'sender1'
    );
    GroupChatModel group2 = GroupChatModel(
      icon: 'icon2',
      groupId: groupIds[1],
      name: "name2",
      lastMessage: 'lastMessage2',
      lastMessageTimestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
      lastMessageSender: 'sender2'
    );
    GroupChatModel group3 = GroupChatModel(
      icon: 'icon3',
      groupId: groupIds[2],
      name: "name3",
    );

    groupsList.add(group1);
    groupsList.add(group2);
    groupsList.add(group3);
    
    yield groupsList;
  }

  // Get the list of members in a group chat
  Future<List<UserModel>> getGroupMembers(String groupId) async {
    List<UserModel> members = [];
    UserModel member1 = UserModel(uid: "01", username: "user1", email: "email1", imageUrl: 'profilePic1');
    UserModel member2 = UserModel(uid: "02", username: "user2", email: "email2", imageUrl: 'profilePic2');
    UserModel member3 = UserModel(uid: "03", username: "user3", email: "email3", imageUrl: 'profilePic3');
    members.add(member1);
    members.add(member2);
    members.add(member3);
    return members;
  }

  // Get the list of messages in a group chat
  Future<List<MessageModel>> getGroupMessages(String groupId) async {
    List<MessageModel> messages = [];
    UserModel sender1 = UserModel(uid: _uid, username: "testUsername", email: "testEmail@mail.it", imageUrl: "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png");
    UserModel sender2 = UserModel(uid: "02", username: "user2", email: "email2", imageUrl: 'profilePic2');
    UserModel sender3 = UserModel(uid: "03", username: "user3", email: "email3", imageUrl: 'profilePic3');

    MessageModel msg1 = MessageModel(
      senderData: sender1,
      message: "Hello",
      timestamp: Timestamp.now(),
      isGif: false
    );
    MessageModel msg2 = MessageModel(
      senderData: sender2,
      message: "Hi",
      timestamp: Timestamp.now(),
      isGif: false
    );
    MessageModel msg3 = MessageModel(
      senderData: sender3,
      message: "GIF",
      timestamp: Timestamp.now(),
      isGif: true
    );
    MessageModel msg4 = MessageModel(
      senderData: sender1,
      message: "GIF",
      timestamp: Timestamp.now(),
      isGif: true
    );
    
    messages.add(msg1);
    messages.add(msg2);
    messages.add(msg3);
    messages.add(msg4);

    return messages;
  }

  // Get the last message in a group chat - STREAM VERSION
  Stream<MessageModel> streamLastMessage(String groupId) async* {
    UserModel sender = UserModel(uid: "01", username: "user1", email: "email1", imageUrl: 'profilePic1');
    MessageModel msg = MessageModel(senderData: sender, message: "Hello", timestamp: Timestamp.now(), isGif: false);
    yield msg;
  }

  /* *** POSITION *** */

  // Add the position of the current user: used in the network page
  Future<bool> addCurrentPosition(PositionModel position) async {
    return true;
  }

  // Remove the position of the current user: used in the network page
  Future<bool> removeCurrentPosition() async {
    return true;
  }

  // Get the list of users with their position ordered by timestamp: used in the network page
  Future<List<UserModel>> getPositionList(String? courseName) async {
    List<UserModel> users = [];
    PositionModel position1 = PositionModel(timestamp: Timestamp.now(), latitude: '1', longitude: '1', description: 'description1', courseName: 'course1');
    PositionModel position2 = PositionModel(timestamp: Timestamp.now(), latitude: '2', longitude: '2', description: '');
    PositionModel position3 = PositionModel(timestamp: Timestamp.now(), latitude: '3', longitude: '3', description: 'description3');
    UserModel user1 = UserModel(uid: getUid(), username: "current user", email: "email1", imageUrl: 'profilePic1', position: position1);
    UserModel user2 = UserModel(uid: "02", username: "user2", firstName: "firstname", lastName:"lastname", email: "email2", imageUrl: 'profilePic2', position: position2);
    UserModel user3 = UserModel(uid: "03", username: "user3", email: "email3", imageUrl: 'profilePic3', position: position3);
    users.add(user1);
    users.add(user2);
    users.add(user3);
    return courseName == 'empty' ? [] : users;
  }

  /* *** COURSES *** */

  // Get the list of courses of the current user
  Future<void> addUserCourse(String courseId) async {}

  Future<bool> removeUserCourse(String courseId) async {
    return true;
  }

  // Get the list of courses of the current user: used in the course and the network page
  Future<List<CourseModel>> getUserCourses(bool isEmpty) async {
    List<CourseModel> courses = [];
    if (!isEmpty) {
      courses.add(CourseModel(courseId: "0", name: "first", description: "description"));
    }
    return courses;
  }

  // Get the list of all the courses: used in the course page
  Future<List<CourseModel>> getAllCourse() async {
    List<CourseModel> courses = [];
    //generate Courses
    courses.add(CourseModel(courseId: "0", name: "first", description: "description"));
    courses.add(CourseModel(courseId: "1", name: "second", description: "description"));
    courses.add(CourseModel(courseId: "2", name: "third", description: "description"));
    return courses;
  }

  /* *** REVIEW *** */

  Future<List<ReviewModel>> getReviews(CourseModel course, String order, int evaluation) async {
    //for testing purpose if the order is "Older" return an empty list, to test all the rendering, otherwise return a list of mock reviews
    List<ReviewModel> reviews = [];
    if (order == "Older") {
      return reviews;
    }
    UserModel otherAuthor = UserModel(uid: "01", username: "user1", email: "test.mail@mail.it", imageUrl: "profilePic1");
    UserModel me = UserModel(uid: "0123456789", username: "me", email: "test1.mail@mail.it", imageUrl: "profilePic2");

    //fill the list with mock reviews
    reviews.add(ReviewModel(id: "01", name: "review1", evaluation: 5, description: "description1", timestamp: Timestamp.now(), author: me));
    reviews.add(ReviewModel(id: "02", name: "review2", evaluation: 4, description: "description2", timestamp: Timestamp.now(), author: me));
    reviews.add(ReviewModel(id: "03", name: "review3", evaluation: 3, description: "description3", timestamp: Timestamp.now(), author: otherAuthor));
    reviews.add(ReviewModel(id: "04", name: "review4", evaluation: 2, description: "description4", timestamp: Timestamp.now(), author: otherAuthor));
    reviews.add(ReviewModel(id: "05", name: "review5", evaluation: 1, description: "description5", timestamp: Timestamp.now(), author: otherAuthor));

    return reviews;
  }

  //load Review in firestore
  Future<bool> addReview(CourseModel course, String name, int evaluation, String? description, Timestamp ts, UserModel author) async {
    return true;
  }

  //delete Review in firestore
  Future<bool> deleteReview(CourseModel course, ReviewModel review) async {
    return true;
  }

  /* *** NOTES *** */

  Future<bool> addNotes(CourseModel course, String name, bool isShared, List<PlatformFile>? attachment, String? description, Timestamp timestamp,
      UserModel author) async {
    return true;
  }

  Future<List<NoteModel>> getNotes(CourseModel course, String order, String preferences) async {
    List<NoteModel> notes = [];

    UserModel otherAuthor = UserModel(uid: "01", username: "user1", email: "test.mail@mail.it", imageUrl: "profilePic1");
    UserModel me = UserModel(uid: "0123456789", username: "me", email: "test1.mail@mail.it", imageUrl: "profilePic2");

    if (order == "Older") {
      return notes;
    }

    notes.add(NoteModel(id: "01", courseId: "id", name: "note1", isShared: true, timestamp: Timestamp.now(), author: me));
    notes.add(NoteModel(id: "02", courseId: "id", name: "note2", isShared: false, timestamp: Timestamp.now(), author: me));
    notes.add(NoteModel(id: "03", courseId: "id", name: "note3", isShared: true, timestamp: Timestamp.now(), author: otherAuthor));

    return notes;
  }

  Future<bool> deleteNote(NoteModel note) async {
    return true;
  }

  Future<bool> UpdateNote(NoteModel note, List<String> toDeleteAttachments, List<PlatformFile>? toUploadAttachments) async {
    return true;
  }
}
