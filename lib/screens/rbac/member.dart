import 'package:flutter/material.dart';

class MemberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member'),
      ),
      body: Center(
        child: Text('Signed In. Role: Member'),
      ),
    );
  }
}
