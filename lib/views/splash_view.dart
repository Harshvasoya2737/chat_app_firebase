import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view.dart';
import 'home_view.dart';
import '../controllers/auth_controller.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return FutureBuilder(
      future: authController.initializeUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return authController.user != null ? HomeView() : LoginView();
        }
      },
    );
  }
}
