import 'package:chat_apps_firebase/utils/helpers/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = " ";
  String password = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Login Screen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        height: 1000,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xff1C2E46),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60), topRight: Radius.circular(60))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: validateAndSignUp,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: validateAndSignIn,
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                "Sign In with Google",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Map<String, dynamic> res =
                    await AuthHelper.authHelper.signInWithGoogle();
                if (res['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign in succesfull..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pushNamed(context, "/", arguments: res["user"]);
                } else if (res["error"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In Failed..."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  validateAndSignUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign UP"),
            content: Form(
              key: signUpFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (val) {
                      return (val!.isEmpty) ? "Enter email first" : null;
                    },
                    onSaved: (val) {
                      email = val!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter email",
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      return (val!.isEmpty) ? "Enter password first" : null;
                    },
                    onSaved: (val) {
                      password = val!;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter password",
                      labelText: "Password",
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              OutlinedButton(
                child: Text("Sign Up"),
                onPressed: () async {
                  if (signUpFormKey.currentState!.validate()) {
                    signUpFormKey.currentState!.save();

                    Map<String, dynamic> res = await AuthHelper.authHelper
                        .signUpUser(email: email, password: password);

                    if (res["user"] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("User Sign Up Successfully..."),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      Navigator.pop(context);
                    } else if (res["error"] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${res["error"]}"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                    emailController.clear();
                    passwordController.clear();

                    email = "";
                    password = "";
                  }
                },
              ),
            ],
          );
        });
  }

  validateAndSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign In"),
        content: Form(
          key: signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter password first" : null;
                },
                onSaved: (val) {
                  password = val!;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter password",
                  labelText: "Password",
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              emailController.clear();
              passwordController.clear();
              Navigator.pop(context);
            },
          ),
          OutlinedButton(
            child: Text("Sign In"),
            onPressed: () async {
              if (signInFormKey.currentState!.validate()) {
                signInFormKey.currentState!.save();

                Map<String, dynamic> res = await AuthHelper.authHelper
                    .signInUser(email: email, password: password);

                if (res["user"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User Sign In Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (route) => false,
                      arguments: res["user"]);
                } else if (res["error"] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${res["error"]}"),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }

                emailController.clear();
                passwordController.clear();

                email = " ";
                password = " ";
              }
            },
          ),
        ],
      ),
    );
  }
}
