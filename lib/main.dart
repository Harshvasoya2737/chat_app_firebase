import 'package:chat_apps_firebase/firebase_options.dart';
import 'package:chat_apps_firebase/views/chat_page.dart';
import 'package:chat_apps_firebase/views/home_page.dart';
import 'package:chat_apps_firebase/views/login_screen.dart';
import 'package:chat_apps_firebase/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash_screen",
      routes: {
        "splash_screen":(context) => SplashScreen(),
        "login_screen":(context) => LoginScreen(),
        "/":(context) => HomePage(),
        "Chat_page":(context) => ChatPage(),
      },
    );
  }
}
