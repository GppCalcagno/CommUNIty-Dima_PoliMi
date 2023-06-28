import 'package:dima_project/Atest_lib/widgets/login/loginform_widget.dart';
import 'package:dima_project/Atest_lib/widgets/login/registrationform_widget.dart';

import 'package:flutter/material.dart';
import 'package:dima_project/layout_dimension.dart'; //not to overwrite

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
                padding: const EdgeInsets.all(65.0),
                child: Container(
                  key: const Key("loginImage"),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/login.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,

            // ignore_for_file: prefer_const_constructors
            // ignore: prefer_const_literals_to_create_immutables

            children: <Widget>[
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
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'quicksand'),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'UNI',
                        style:
                            TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 105, 52, 250), fontFamily: 'quicksand')),
                    TextSpan(text: 'ty', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'quicksand')),
                  ],
                ),
              ),
              login ? LoginForm() : RegistrationForm(),
              SizedBox(height: 20),
              TextButton(
                onPressed: toggleState,
                child: login ? Text("No Account? Sign Up") : Text("Already Registered? Sign In"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
