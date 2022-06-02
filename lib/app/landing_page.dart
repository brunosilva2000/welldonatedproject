import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:welldonatedproject/app/sign_in/sign_in_page.dart';

import '../services/auth.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User? _user;

  void _updateUser(User user) {
    print('User id: ${user.uid}');
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        auth: Auth(),
        onSignIn: (user) => _updateUser(user!),
      );
    } else {
      return Container();
    }
  }
}
