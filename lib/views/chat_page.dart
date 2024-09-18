import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/helpers/firestore_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String receiverEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Color(0xdd1C2E46),
      appBar: AppBar(
        title: Text(
          "${receiverEmail}",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Color(0xff1C2E46),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 670,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 18,
                  child: FutureBuilder(
                    future: FirestoreHelper.firestoreHelper
                        .fetchAllMessages(receiverEmail: receiverEmail),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("ERROR: ${snapshot.error}"),
                        );
                      } else if (snapshot.hasData) {
                        Stream<QuerySnapshot<Map<String, dynamic>>>?
                            messagesStream = snapshot.data;

                        return StreamBuilder(
                          stream: messagesStream,
                          builder: (context, ss) {
                            if (ss.hasError) {
                              return Center(
                                child: Text("ERROR: ${ss.error}"),
                              );
                            } else if (ss.hasData) {
                              QuerySnapshot<Map<String, dynamic>>? data =
                                  ss.data;

                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  allDocs = (data == null) ? [] : data.docs;

                              return (allDocs.isEmpty)
                                  ? Center(
                                      child: Text("No any messages yet..."),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 45),
                                      child: ListView.builder(
                                        reverse: true,
                                        itemCount: allDocs.length,
                                        itemBuilder: (context, i) {
                                          return Row(
                                            mainAxisAlignment: (receiverEmail ==
                                                    allDocs[i].data()['sender'])
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: (receiverEmail ==
                                                          allDocs[i]
                                                              .data()['sender'])
                                                      ? Colors.black
                                                      : Color(0xff1C2E46),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  "${allDocs[i].data()['msg']}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                            }

                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(50)),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              hintText: "Type a message",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black54),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          String msg = messageController.text;
                          await FirestoreHelper.firestoreHelper
                              .sendMessage(msg: msg, receiver: receiverEmail);

                          messageController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
