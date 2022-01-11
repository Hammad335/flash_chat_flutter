// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_flutter/screens/login_screen.dart';
import 'package:flash_chat_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation animation1;
  bool isForwardAnimComplete = false;
  late AnimationController controller1;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    controller.forward();
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.addListener(() {
      setState(() {});
    });

    controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation1 = CurvedAnimation(parent: controller1, curve: Curves.easeIn);
    controller1.forward();
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isForwardAnimComplete = true;
        controller1.reverse(from: 1.0);
      }
    });
    controller1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: isForwardAnimComplete
                        ? ((animation1.value * 100 >= 60)
                            ? animation1.value * 100
                            : 60.0)
                        : animation1.value * 100,
                  ),
                ),
                getTextWidget(),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              buttonText: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              color: Colors.blueAccent,
              buttonText: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextWidget() {
    if (isForwardAnimComplete && animation1.value == 0.0) {
      return AnimatedTextKit(
        totalRepeatCount: 2,
        animatedTexts: [
          TypewriterAnimatedText(
            'Flash Chat',
            speed: Duration(milliseconds: 110),
            textStyle: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      );
    } else {
      return Text('');
    }
  }
}
