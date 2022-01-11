// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showLoadingSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonText: 'Log In',
                onPressed: () async {
                  setState(() {
                    showLoadingSpinner = true;
                  });
                  try {
                    if (!validateData()) {
                      setState(() {
                        showLoadingSpinner = false;
                        return;
                      });
                    }

                    final userCredentials =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    if (userCredentials != null) {
                      if (userCredentials.user!.emailVerified) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Kindly verify your email address.',
                            textColor: Colors.white,
                            backgroundColor: Colors.black);
                      }
                    }
                    setState(() {
                      showLoadingSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showLoadingSpinner = false;
                    });

                    int index = e.toString().indexOf(']');
                    Fluttertoast.showToast(
                        msg: e.toString().substring(index + 1),
                        textColor: Colors.white,
                        backgroundColor: Colors.black);

                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateData() {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Email is required.');
      return false;
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: 'Password is required.');
      return false;
    }
    return true;
  }
}
