import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../services/auth.dart';

import '_wrapper_admin.dart';
import '_wrapper_anon.dart';
import '_wrapper_member.dart';

class NavWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    if (user == null) {
      return AnonWrapper();
    } else {
      return BaseWrapper();
    }
  }
}

class BaseWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getRole() async {
      final token = await Provider.of<AuthService>(context).claims;
      final String roleClaim = token['role'];
      final String role = roleClaim ?? 'member';
      return role;
    }

    return Consumer<AuthService>(
      builder: (context, auth, child) {
        return FutureBuilder(
          future: _getRole(),
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case 'member':
                return MemberWrapper();
                break;
              case 'admin':
                return AdminWrapper();
                break;
              default:
                return MemberWrapper();
                break;
            }
          },
        );
      },
    );
  }
}
