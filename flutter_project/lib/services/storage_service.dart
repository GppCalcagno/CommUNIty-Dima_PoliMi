import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../classes/file_model.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Get the list of available avatars: used in the settings page
  Future<List<String>> getAllAvatars() async {
    ListResult res = await storage.ref().child('avatar').listAll();
    List<String> urls = [];
    for (var item in res.items) {
      urls.add(await item.getDownloadURL());
    }
    return urls;
  }

  // Upload the profile picture of the current user and return the url: used in the settings page
  Future<String?> uploadProfilePic(File image) async {
    Reference ref = storage.ref().child('profilepic/${uid}_profilepic.png');
    await ref.putFile(image);
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Remove the profile picture of the current user: used in the settings page
  Future<bool> removeProfilePic() async {
    try {
      await storage.ref().child('profilepic/${uid}_profilepic.png').getDownloadURL().then((value) async {
        await storage.refFromURL(value).delete();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadDocuments(File image) async {
    Reference ref = storage.ref().child('profilepic/${uid}_profilepic.png');
    await ref.putFile(image);

    return await ref.getDownloadURL();
  }

  //Upload the list of attachment of a New Created Notes
  Future<List<FileModel>?> uploadNoteFile(List<PlatformFile>? files, String courseId, String noteID) async {
    List<FileModel> urls = [];
    if (files != null) {
      for (var x in files) {
        Reference ref = storage.ref().child('/notedoc/${courseId}/${noteID}/${x.name}');
        await ref.putFile(File(x.path!));
        String url = await ref.getDownloadURL();
        urls.add(FileModel(name: x.name, url: url));
      }
      return urls;
    }
    return null;
  }

  Future<List<FileModel>?> getNoteAttachments(String courseId, String noteID) async {
    ListResult res = await storage.ref().child('/notedoc/${courseId}/${noteID}').listAll();
    if (res.items.isEmpty) {
      return null;
    }

    List<FileModel> urls = [];
    for (var item in res.items) {
      urls.add(FileModel(name: item.name, url: await item.getDownloadURL()));
    }
    return urls;
  }

  Future<bool> deleteAllNoteAttachments(String courseId, String noteID) async {
    try {
      await FirebaseStorage.instance.ref('/notedoc/${courseId}/${noteID}').listAll().then((value) {
        value.items.forEach((element) {
          print(element);
          FirebaseStorage.instance.ref(element.fullPath).delete();
        });
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> deleteNoteAttachment(String courseId, String noteID, List<String> attachmentsName) async {
    try {
      for (var x in attachmentsName) {
        Reference file = FirebaseStorage.instance.ref('/notedoc/${courseId}/${noteID}/${x}');
        await FirebaseStorage.instance.ref(file.fullPath).delete();
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
