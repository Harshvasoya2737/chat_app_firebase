import 'package:flutter/material.dart';
import '../controllers/message_controller.dart';
import '../models/message_model.dart';


class MessageScreen extends StatefulWidget {
  final String currentUserEmail;
  final String receiverEmail;

  MessageScreen({required this.currentUserEmail, required this.receiverEmail});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController _messageController = MessageController();
  final TextEditingController _messageControllerField = TextEditingController();

  void sendMessage() async {
    if (_messageControllerField.text.isNotEmpty) {
      final message = MessageModel(
        sender: widget.currentUserEmail,
        receiver: widget.receiverEmail,
        message: _messageControllerField.text,
        timestamp: DateTime.now(),
      );
      await _messageController.sendMessage(message);
      _messageControllerField.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _messageController.getMessages(
                  widget.currentUserEmail, widget.receiverEmail),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isCurrentUser =
                        message.sender == widget.currentUserEmail;
                    return ListTile(
                      title: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blue[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(message.message),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageControllerField,
                    decoration: InputDecoration(hintText: "Type your message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
