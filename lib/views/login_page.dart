import 'package:flutter/material.dart';
import '../controllers/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signInWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signUpWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signInWithGoogle();
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
