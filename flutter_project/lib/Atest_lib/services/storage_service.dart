import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:dima_project/classes/file_model.dart';

class StorageService {
  final String uid = "0123456789";

  String getUid() {
    return uid;
  }

  // Get the list of available avatars: used in the settings page
  Future<List<String>> getAllAvatars() async {
    List<String> urls = [
      "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png",
      "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png"
    ];

    return urls;
  }

  // Upload the profile picture of the current user and return the url: used in the settings page
  Future<String?> uploadProfilePic(File image) async {
    return "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png";
  }

  // Remove the profile picture of the current user: used in the settings page
  Future<bool> removeProfilePic() async {
    return true;
  }

  Future<String> uploadDocuments(File image) async {
    return "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png";
  }

  //Upload the list of attachment of a New Created Notes
  Future<List<FileModel>?> uploadNoteFile(List<PlatformFile>? files, String courseId, String noteID) async {
    List<FileModel> urls = [];
    //TODO
    return null;
  }

  Future<List<FileModel>?> getNoteAttachments(String courseId, String noteID) async {
    //TODO
    return null;
  }

  Future<bool> deleteAllNoteAttachments(String courseId, String noteID) async {
    return true;
  }

  Future<bool> deleteNoteAttachment(String courseId, String noteID, List<String> attachmentsName) async {
    return true;
  }
}
