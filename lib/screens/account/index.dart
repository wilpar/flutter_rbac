import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/auth.dart';

import '../auth/authenticate.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  signInSignOutTile(context),
                ],
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  signInSignOutTile(context) {
    final user = Provider.of<AppUser>(context);
    final AuthService _auth = AuthService();

    if (user == null) {
      return ListTile(
        title: Text('Sign In or Sign Up'),
        leading: Icon(Icons.login),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Authenticate()),
          );
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.logout),
        title: Text(
          'Sign Out',
        ),
        onTap: () async {
          await _auth.signOut();
        },
      );
    }
  }
}
