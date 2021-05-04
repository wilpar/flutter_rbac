import 'package:flutter/material.dart';

import '../../extensions/validate_email.dart';
import '../../services/auth.dart';
import '../../services/auth_exception.dart';
import '../../widgets/loading.dart';

enum Role { patron, muse }

class SignUpWrapper extends StatelessWidget {
  final Function toggleView;
  SignUpWrapper({this.toggleView});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 2,
        title: Text(
          'Authenticating',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: (size.width > 600 && size.height > 600)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 480,
                    height: 380,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple[100]),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(8),
                      ),
                    ),
                    child: SignUp(toggleView),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: SignUp(toggleView),
            ),
    );
  }
}

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Create your Account',
                      style: Theme.of(context).textTheme.headline5),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text('Its free to connect.'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val.isValidEmail() ? null : "Check your email",
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (val) =>
                            val.length < 6 ? '6 or more characters' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'First / Given Name',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (val) =>
                            val.length < 2 ? 'We need this for your Reservations' : null,
                        onChanged: (val) {
                          setState(() => firstName = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Last Name or Initial',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (val) =>
                            val.length < 1 ? 'Don\'t be shy!' : null,
                        onChanged: (val) {
                          setState(() => lastName = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              'Sign in instead',
                            ),
                          ),
                          ElevatedButton(
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic status =
                                      await _auth.registerWithEmail(
                                    email: email,
                                    password: password,
                                    firstName: firstName,
                                    lastName: lastName,
                                  );
                                  if (status != AuthResultStatus.successful) {
                                    setState(() => loading = false);
                                    final errorMsg = AuthExceptionHandler
                                        .generateExceptionMessage(status);
                                    _showAlertDialog(errorMsg);
                                  } else {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    // setState(() => loading = false);
                                  }
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  _showAlertDialog(errorMsg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Registration Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }
}
