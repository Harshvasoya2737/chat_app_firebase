import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatMessages(String user1, String user2) {
    return _db
        .collection('messages')
        .doc(user1)
        .collection(user2)
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> sendMessage(String message, String senderId, String receiverId) async {
    final messageData = {
      'text': message,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _db
        .collection('messages')
        .doc(senderId)
        .collection(receiverId)
        .add(messageData);

    // Store the message for the receiver as well
    await _db
        .collection('messages')
        .doc(receiverId)
        .collection(senderId)
        .add(messageData);
  }
}
