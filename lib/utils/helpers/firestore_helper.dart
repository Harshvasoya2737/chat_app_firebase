import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_helper.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> adduser({required String email, required String uid}) async{
    await firebaseFirestore.collection("users").add({
      "email":email,
      "uid":uid,
    });
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> fetchallusers(){
    return firebaseFirestore.collection("users").snapshots();
  }
  Future<void> sendMessage(
      {required String msg, required String receiver}) async {

    bool isChatroomExists = false;

    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;

    QuerySnapshot<Map<String, dynamic>> res =
    await firebaseFirestore.collection("chatrooms").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms = res.docs;

    String? chatroomId;

    allChatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      Map<String, dynamic> data = chatroom.data();

      List users = data['users'];

      if (users.contains(receiver) && users.contains(senderEmail)) {
        isChatroomExists = true;
        chatroomId = chatroom.id;
      }
    });

    if (isChatroomExists == false) {
      DocumentReference<Map<String, dynamic>> docRef =
      await firebaseFirestore.collection("chatrooms").add({
        "users": [
          receiver,
          senderEmail,
        ],
      });

      chatroomId = docRef.id;
    }

    await firebaseFirestore
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add({
      "msg": msg,
      "sender": senderEmail,
      "receiver": receiver,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchAllMessages(
      {required String receiverEmail}) async {
    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;

    QuerySnapshot<Map<String, dynamic>> res =
    await firebaseFirestore.collection("chatrooms").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms = res.docs;

    String? chatroomId;

    allChatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      Map<String, dynamic> data = chatroom.data();

      List users = data['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomId = chatroom.id;
      }
    });

    return firebaseFirestore
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
