import 'package:flutter/material.dart';

class AnonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anon'),
      ),
      body: Center(
        child: Text('You are not signed in.'),
      ),
    );
  }
}
