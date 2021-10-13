import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:messenger_clone/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messenger",
        ),
      ),
      body: Center(
        child: Container(
          height: 70.0,
          child: SignInButton(
            Buttons.Google,
            onPressed: () {
              AuthMethods().signInWithGoogle(context);
            },
          ),
        ),
      ),
    );
  }
}
