import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dima_project/Atest_lib/services/database_service.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool _isPasswordSixCharacters = false;
  bool _isEmailWellFormatted = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    super.dispose();
  }

  onPasswordChanged(String password) {
    setState(() {
      _isPasswordSixCharacters = false;
      if (password.length >= 6) _isPasswordSixCharacters = true;
    });
  }

  onEmailChange(String email) {
    final emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

    setState(() {
      _isEmailWellFormatted = false;
      if (emailRegex.hasMatch(email)) _isEmailWellFormatted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      width: 400,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey("reg_mail"),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => onEmailChange(value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter Your Email',
                    labelText: 'Email ',
                  ),
                  controller: email,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey("reg_pass"),
                  onChanged: (password) => onPasswordChanged(password),
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.key),
                    hintText: 'Do not Share it!',
                    labelText: 'Password',
                  ),
                  controller: password,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      key: const ValueKey("reg_email_check"),
                      duration: const Duration(milliseconds: 500),
                      width: 1,
                      height: 10,
                      decoration: BoxDecoration(
                          color: _isEmailWellFormatted ? Colors.green : Colors.blueGrey,
                          border: _isEmailWellFormatted ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Icon(
                          _isEmailWellFormatted ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Well formatted email address",
                      textScaleFactor: 0.01,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    AnimatedContainer(
                      key: const ValueKey("reg_pass_check"),
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: _isPasswordSixCharacters ? Colors.green : Colors.blueGrey,
                          border: _isPasswordSixCharacters ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Icon(
                          _isPasswordSixCharacters ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    const Text(
                      "Password contains at least 6 characters",
                      textScaleFactor: 0.01,
                    )
                  ],
                ),
                ElevatedButton.icon(
                    key: const ValueKey("reg_btn"),
                    style: ElevatedButton.styleFrom(
                      //change width and height on your need width = 200 and height = 50
                      minimumSize: const Size(250, 50),
                    ),
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text("Sign Up"),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        FutureBuilder(
                          future: signUp(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return const Text("Done");
                            } else {
                              return const Text("Loading");
                            }
                          },
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    Navigator.pushNamed(context, '/courses');
  }
}
