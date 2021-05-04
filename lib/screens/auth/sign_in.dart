import 'package:flutter/material.dart';

import '../../extensions/validate_email.dart';
import '../../services/auth.dart';
import '../../services/auth_exception.dart';
import '../../widgets/loading.dart';

import 'reset_password.dart';

class SignInWrapper extends StatelessWidget {
  final Function toggleView;
  SignInWrapper({this.toggleView});

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
      body: (size.width > 600 && size.height > 520)
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
                    child: SignIn(toggleView),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: SignIn(toggleView),
            ),
    );
  }
}

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

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
                  child: Text('Sign In',
                      style: Theme.of(context).textTheme.headline5),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text('Use your Email Address'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              'Forgot password?',
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ResetPassword();
                                    },
                                    fullscreenDialog: true),
                              );
                            },
                          ),
                          ElevatedButton(
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic status =
                                    await _auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                if (status != AuthResultStatus.successful) {
                                  setState(() => loading = false);
                                  final errorMsg = AuthExceptionHandler
                                      .generateExceptionMessage(status);
                                  _showAlertDialog(errorMsg);
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                      Text(error),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 32.0,
                    // alignment: WrapAlignment.spaceAround,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          'Join Us - it\'s Free',
                        ),
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
              'Sign In Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }
}
