import 'package:chat_apps_firebase/utils/helpers/auth_helper.dart';
import 'package:chat_apps_firebase/utils/helpers/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      backgroundColor: Color(0xff1C2E46),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Quick Chat",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Color(0xff1C2E46),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              return _showLogoutDialog(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1C2E46), Color(0xff1F4C73)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: StreamBuilder(
              stream: FirestoreHelper.firestoreHelper.fetchallusers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error:${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      (data == null) ? [] : data.docs;

                  return ListView.builder(
                    itemCount: allDocs.length,
                    itemBuilder: (context, index) {
                      return (AuthHelper.firebaseAuth.currentUser!.email ==
                              allDocs[index].data()["email"])
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1C2E46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  elevation: 5,
                                ),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    title: Text(
                                      "${allDocs[index].data()["email"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    trailing: Icon(
                                      Icons.chat,
                                      color: Colors.blueAccent,
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, "Chat_page",
                                          arguments:
                                              allDocs[index].data()["email"]);
                                    },
                                  ),
                                ),
                              ),
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
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff1C2E46),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1C2E46), Color(0xff1F4C73)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: (user == null)
                    ? null
                    : (user.photoURL == null)
                        ? null
                        : NetworkImage(user.photoURL as String),
              ),
            ),
            (user == null)
                ? Container()
                : Text(
                    "Email: ${user.email}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                return _showLogoutDialog(context);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                await AuthHelper.authHelper.signOutUser();
                Navigator.pushNamedAndRemoveUntil(context, "login_screen",
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
