import 'package:dima_project/widgets/login/loginform_widget.dart';
import 'package:dima_project/widgets/login/registrationform_widget.dart';
import 'package:flutter/material.dart';

import 'layout_dimension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  bool login = true;

  void toggleState() {
    setState(() {
      login = !login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text(""), automaticallyImplyLeading: false),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (MediaQuery.of(context).size.width > limitWidth)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/login.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            width: MediaQuery.of(context).size.width > limitWidth ? 600 : MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,

              // ignore_for_file: prefer_const_constructors
              // ignore: prefer_const_literals_to_create_immutables

              children: <Widget>[
                Image(image: AssetImage("assets/appIcon_round.png"), width: 80),
                SizedBox(height: 10),
                Text(
                  ' Welcome to',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                    text: 'comm',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness != Brightness.dark ? Colors.black : Colors.white,
                        fontFamily: 'quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'UNI',
                          style: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 105, 52, 250), fontFamily: 'quicksand')),
                      TextSpan(
                          text: 'ty',
                          style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness != Brightness.dark ? Colors.black : Colors.white,
                              fontFamily: 'quicksand')),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                login ? LoginForm() : RegistrationForm(),
                SizedBox(height: 20),
                TextButton(
                  onPressed: toggleState,
                  child: login ? Text("No Account? Sign Up") : Text("Already Registered? Sign In"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
