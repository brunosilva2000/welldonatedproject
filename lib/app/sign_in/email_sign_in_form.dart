import 'package:flutter/material.dart';
import 'package:welldonatedproject/common_widgets/form_submit_button.dart';

enum EnailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EnailSignInFormType _formType = EnailSignInFormType.signIn;

  void _submit() {
    print('email: ${_emailController.text}, password: ${_passwordController.text}');

  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EnailSignInFormType.signIn ?
      EnailSignInFormType.register : EnailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EnailSignInFormType.signIn ?
        'Sign in' : 'Create an account';
    final secondaryText = _formType == EnailSignInFormType.signIn ?
    'Need an account? Register' : 'Have an account? Sign in';

    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'E-mail',
        ),
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(height: 15.0),
      FormSubmitButton(
          text: primaryText,
          onPressed: _submit,
      ),
      SizedBox(height: 8.0),
      FlatButton(
          onPressed: (_toggleFormType) ,
          child: Text(secondaryText),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
