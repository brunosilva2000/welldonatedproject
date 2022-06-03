import 'package:flutter/material.dart';
import 'package:welldonatedproject/services/auth.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({Key? key, required this.auth, required this.child,}) : super(key: key, child: child);
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider? provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider!.auth;
  }
}