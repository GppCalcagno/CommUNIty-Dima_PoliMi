//not necessary to overwrite

import 'package:flutter/material.dart';

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
                  key: const ValueKey("mail"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
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
                TextFormField(
                  key: const ValueKey("password"),
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.key),
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
                    //change width and height on your need width = 200 and height = 50
                    minimumSize: Size(250, 50),
                    //backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[600],
                  ),
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: Text("Sign In With Google"),
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
    Navigator.pushNamed(context, '/courses');
  }

  signInWithGoogle() async {
    Navigator.pushNamed(context, '/courses');
  }
}
