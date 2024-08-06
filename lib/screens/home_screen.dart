import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'email_list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _storeEmail(widget.user?.email);
  }

  Future<void> _storeEmail(String? email) async {
    if (email != null) {
      final emailCollection = _firestore.collection('emails');
      final emailDoc = emailCollection.doc(email);
      await emailDoc.set({'email': email}, SetOptions(merge: true));
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<String?> _getStoredEmail() async {
    final emailCollection = _firestore.collection('emails');
    final snapshot = await emailCollection.limit(1).get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first['email'] as String : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${widget.user?.email ?? 'Guest'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Email List'),
              onTap: () async {
                final storedEmail = await _getStoredEmail();
                if (storedEmail != null && storedEmail == widget.user?.email) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmailListScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email not found or not valid.')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Email: ${widget.user?.email ?? 'No Email'}'),
      ),
    );
  }
}
