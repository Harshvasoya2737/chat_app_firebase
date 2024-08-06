import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _getStoredEmails() async {
    final emailCollection = _firestore.collection('emails');
    final snapshot = await emailCollection.get();
    return snapshot.docs.map((doc) => doc['email'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email List'),
      ),
      body: FutureBuilder<List<String>>(
        future: _getStoredEmails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No emails stored.'));
          } else {
            final emails = snapshot.data!;
            return ListView.builder(
              itemCount: emails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(emails[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
