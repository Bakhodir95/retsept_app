import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class PhotoCloudStorageService {
  final FirebaseStorage _firebaseStorage;

  PhotoCloudStorageService({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    try {
      final storageRef = _firebaseStorage
          .ref()
          .child('user_images/${DateTime.now().toString()}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      // print()
      return imageUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}
