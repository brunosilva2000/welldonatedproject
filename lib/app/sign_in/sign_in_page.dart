import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/sign_in/email_sign_in_page.dart';
import 'package:welldonatedproject/app/sign_in/sign_in_manager.dart';
import 'package:welldonatedproject/app/sign_in/sign_in_button.dart';
import 'package:welldonatedproject/common_widgets/show_exception_alert_dialog.dart';
import 'package:welldonatedproject/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Falha ao iniciar sessão',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Well Donated'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(),
          SizedBox(
            height: 48.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Iniciar sessão com e-mail',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'ou',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Iniciar sessão como anónimo',
            textColor: Colors.black,
            color: Colors.lime,
            onPressed: () {
              _signInAnonymously(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if(isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Iniciar Sessão',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,

      ),
    );
  }
}
