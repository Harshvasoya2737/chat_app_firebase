import 'package:chat_apps_firebase/utils/helpers/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signUpUser(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      res["user"] = user;
      await FirestoreHelper.firestoreHelper.adduser(
          email: user!.email!, uid: user!.uid);
    } on FirebaseAuthException catch (e) {
      res["error"] = "Sign Up failed......";
    }

    return res;
  }

  Future<Map<String, dynamic>> signInUser(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      res["user"] = user;
    } on FirebaseAuthException catch (e) {
      res["error"] = "Sign In failed......";
    }

    return res;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> res = {};

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);

      User? user = userCredential.user;

      res["user"] = user;
      await FirestoreHelper.firestoreHelper.adduser(
          email: user!.email!, uid: user!.uid);
    } catch (e) {
      res["error"] = "Sign In with Google failed.....";
    }

    return res;
  }

  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
