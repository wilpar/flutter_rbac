import 'package:flutter/material.dart';

import '../../extensions/validate_email.dart';
import '../../services/auth.dart';
import '../../widgets/loading.dart';

class ResetPasswordWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(8),
                      ),
                    ),
                    child: ResetPassword(),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: ResetPassword(),
            ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 36.0),
        ),
      ),
      body: loading
          ? Loading()
          : Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Reset Your Password',
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
                          decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (val) =>
                              val.isValidEmail() ? null : "Check your email",
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          child: Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              await _auth.resetPassword(email);
                              setState(() => loading = false);
                              _showAlertDialog();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _showAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Check Your Email',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
                'If there is an account with that email, we\'ve sent a link to reset your password.'),
            actions: [
              new TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (Route<dynamic> route) => route.isFirst,
                  );
                },
              ),
            ],
          );
        });
  }
}
