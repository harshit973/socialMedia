import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // This class handles methods related to Firebase Storage.

  // Method for uploading an image to Firebase Storage.
  Future<String> uploadImageToStorage(
      String childname, Uint8List file, bool isPost) async {
    // Create a reference to a location in Firebase Storage where the image will be stored.
    // The 'childname' parameter specifies a subdirectory within the storage.
    // The user's unique ID is used as a subdirectory to organize their uploaded images.
    Reference ref = _firebaseStorage
        .ref()
        .child(childname)
        .child(_firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    // Start the upload task by putting the image data into the specified reference.
    UploadTask uploadTask = ref.putData(file);

    // Wait for the upload task to complete and get a snapshot of the task.
    TaskSnapshot snap = await uploadTask;

    // Get the download URL of the uploaded image from the snapshot.
    String downloadUrl = await snap.ref.getDownloadURL();

    // Return the download URL, which can be used to access the uploaded image.
    return downloadUrl;
  }
}
