import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'chat_view.dart';
import 'login_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: authController.emailList.length,
        itemBuilder: (context, index) {
          final email = authController.emailList[index];
          return ListTile(
            title: Text(email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(email: email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
