import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/database_service.dart';

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
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => onEmailChange(value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    icon: Icon(Icons.email, color: Colors.deepPurple[400]),
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
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (password) => onPasswordChanged(password),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    icon: Icon(Icons.key, color: Colors.deepPurple[400]),
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
                const SizedBox(height: 35),
                Row(
                  children: [
                    SizedBox(width: 15),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
                      height: 20,
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
                      textScaleFactor: 0.9,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 15),
                    AnimatedContainer(
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
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Password contains at least 6 characters",
                      textScaleFactor: 0.9,
                    )
                  ],
                ),
                const SizedBox(height: 45),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
    //show the circual while registering
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);

      String imageUrl = "https://icons.iconarchive.com/icons/graphicloads/flat-finance/96/person-icon.png";
      String userName = email.text.split("@")[0];

      await userCredential.user?.updatePhotoURL(imageUrl);
      await userCredential.user?.updateDisplayName(userName);

      await DatabaseService().createUser(userName, email.text, imageUrl);

      Navigator.of(context).pop();

      context.go("/courses");
      //remove the circle
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      //remove the circle
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Something goes Wrong'),
          content: Text(e.message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
