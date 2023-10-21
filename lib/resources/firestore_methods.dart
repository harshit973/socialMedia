import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profileImage,
        likes: [],
      );

      _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComments(String postId, String uid, String text, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "postId": postId,
          "text": text,
          "datePublished": DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followUid) async {
    try {
      DocumentSnapshot userSnap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (userSnap.data()! as dynamic)['following'];

      if (following.contains(followUid)) {
        await _firebaseFirestore.collection('users').doc(followUid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followUid])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followUid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followUid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
