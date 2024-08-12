import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
