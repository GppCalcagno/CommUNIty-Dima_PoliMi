import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/classes/position_model.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String imageUrl;
  final String? firstName;
  final String? lastName;
  PositionModel? position;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
    this.firstName,
    this.lastName,
    this.position,
  });

  /// DocumentSnapshot is the data type returned by firestore
  /// Parce Data from DocumentSnapshot, used for getCurrentUser, GetPositionList
  /// use DocumentSnapshot to get also the id of the document
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return UserModel(
      uid: snapshot.id,
      username: data?['username'] ?? "",
      imageUrl: data?['imageUrl'] ?? "",
      email: data?['email'] ?? "",
      firstName: data?['first_name'],
      lastName: data?['last_name'],
      position: data?['position'] != null ? PositionModel.fromMap(data?['position']) : null,
    );
  }

  /// Parce Data from Json (Firebase), used for reviewsRetrival
  /// This method use map (not DocumentSnapshot) so it require the id as element of the entry
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      imageUrl: data['imageUrl'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      position: data['position'] != null ? PositionModel.fromMap(data['position']) : null,
    );
  }

  Map<String, dynamic> toMap(bool? insertID) {
    return {
      if (insertID != null && insertID) 'uid': uid, // used to insert the id in the database (not required for the update
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
      if (position != null) 'position': position!.toMap(),
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }
}
