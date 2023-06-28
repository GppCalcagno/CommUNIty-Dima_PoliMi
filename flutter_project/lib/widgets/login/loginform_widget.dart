// ignore_for_file: prefer_const_constructors

import 'package:dima_project/services/database_service.dart';
import 'package:dima_project/classes/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKeyForgotten = GlobalKey<FormState>();
  final _forgotten = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _email.dispose();
    _password.dispose();
    _forgotten.dispose();
    super.dispose();
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
                  key: const ValueKey("loginmail"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    icon: Icon(Icons.email, color: Colors.deepPurple[400]),
                    hintText: 'Enter Your Email',
                    labelText: 'Email',
                  ),
                  controller: _email,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: const ValueKey("loginpassword"),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    icon: Icon(Icons.key, color: Colors.deepPurple[400]),
                    hintText: 'Do not Share it!',
                    labelText: 'Password',
                  ),
                  controller: _password,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 45),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    //change width and height on your need width = 200 and height = 50
                    minimumSize: Size(250, 50),
                  ),
                  icon: const Icon(Icons.login),
                  key: const ValueKey("signInButton"),
                  label: Text("Sign In"),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      signIn(_email.text, _password.text);
                    }
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    //change width and height on your need width = 200 and height = 50
                    minimumSize: Size(250, 50),
                    //backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[600],
                  ),
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: Text("Sign In with Google"),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    signInWithGoogle();
                  },
                ),
                TextButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Don\'t Worry!'),
                        content: Form(
                          key: _formKeyForgotten,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Insert your email and we'll send you a link to reset your password!"),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.email),
                                  hintText: 'Enter Your Email',
                                  labelText: 'Email',
                                ),
                                controller: _forgotten,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty || !value.contains("@") || !value.contains(".")) {
                                    return 'Please check your email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKeyForgotten.currentState!.validate()) {
                                  //send email
                                  try {
                                    FirebaseAuth.instance.sendPasswordResetEmail(email: _forgotten.text);
                                    _forgotten.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Password Reset email sent')),
                                    );
                                  } catch (e) {}

                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Submit'))
                        ],
                      ),
                    )
                  },
                  child: Text("Forgot Password?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn(String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      debugPrint("Trying to Login...");
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      //remove the circle
      debugPrint("Signed In");
      Navigator.of(context).pop();
      context.go("/courses");
    } on FirebaseAuthException catch (e) {
      //remove the circle
      Navigator.of(context).pop();
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

  signInWithGoogle() async {
    debugPrint("Signing In with google...");
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      DatabaseService db = DatabaseService();
      UserModel user = await db.getCurrentUser();

      //New User Connected With Google
      if (user.email == "") {
        debugPrint("LoginForm: Store New User Data (from Google)");
        String username = FirebaseAuth.instance.currentUser!.displayName.toString().split(" ")[0];
        String mail = FirebaseAuth.instance.currentUser!.email!;
        String imageUrl = FirebaseAuth.instance.currentUser!.photoURL.toString();

        await db.createUser(username, mail, imageUrl);
      } else {
        debugPrint("LoginForm: Login Already Stored User");
      }

      //remove the circle
      Navigator.of(context).pop();

      context.go("/courses");
    } on FirebaseAuthException catch (e) {
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
