import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessages(String currentUserEmail, String receiverEmail) {
    return _firestore
        .collection('messages')
        .where('sender', whereIn: [currentUserEmail, receiverEmail])
        .where('receiver', whereIn: [currentUserEmail, receiverEmail])
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromJson(doc.data())).toList());
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('messages').add(message.toJson());
  }
}
