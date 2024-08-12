import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  List<String> emailList = [];

  AuthController() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    user = _auth.currentUser;
    if (user != null) {
      await _updateEmailList();
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await _updateEmailList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await _updateEmailList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      user = userCredential.user;
      await _updateEmailList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    user = null;
    emailList.clear();
    notifyListeners();
  }

  Future<void> _updateEmailList() async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final userData = {
      'email': user!.email,
      'lastSignIn': FieldValue.serverTimestamp(),
    };
    await userRef.set(userData, SetOptions(merge: true));

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastSignIn', descending: true)
        .get();
    emailList = querySnapshot.docs.map((doc) => doc.data()['email'] as String).toList();
  }
}
