import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _showSnackBar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _checkIfUserExists(String email) async {
    try {
      final result = await _auth.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking if user exists: $e");
      return false;
    }
  }

  Future<void> _showSignUpDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sign Up'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _signUpWithEmail();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signUpWithEmail() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (await _checkIfUserExists(email)) {
      await _showSnackBar('Account already exists. Please sign in.');
    } else {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _storeEmail(email);
        await _showAlertDialog('Sign Up Successful', 'Your account has been created successfully.');
      } catch (e) {
        print("Error signing up with email: $e");
        await _showAlertDialog('Sign Up Failed', 'An error occurred during sign up. Please try again.');
      }
    }
  }

  Future<void> _showAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _showSnackBar('Login successful.');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(user: userCredential.user)));
    } catch (e) {
      print("Error signing in with email: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      await _showSnackBar('Google Sign-In successful.');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(user: userCredential.user)));
    } catch (e) {
      print("Error signing in with Google: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      await _showSnackBar('Signed in anonymously successfully.');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(user: userCredential.user)));
    } catch (e) {
      print("Error signing in anonymously: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _storeEmail(String? email) async {
    if (email != null) {
      final emailCollection = _firestore.collection('emails');
      final emailDoc = emailCollection.doc(email);
      await emailDoc.set({'email': email}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/desktop-wallpaper-login-page.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 32),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Sign In with Email'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _showSignUpDialog,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Sign Up with Email'),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: FaIcon(FontAwesomeIcons.google),
                  label: Text('Sign In with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _signInAnonymously,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Sign In Anonymously'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
