import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(email: userCredential.user!.email!);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _addUserToFirestore(userCredential.user!.email!);
      return UserModel(email: userCredential.user!.email!);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _addUserToFirestore(String email) async {
    final userCollection = _firestore.collection('users');
    final userDoc = await userCollection.doc(email).get();
    if (!userDoc.exists) {
      await userCollection.doc(email).set(UserModel(email: email).toJson());
    }
  }
}
