import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/home/jobs/PubListTile.dart';
import 'package:welldonatedproject/app/home/jobs/edit_pub_page.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/common_widgets/show_alert_dialog.dart';
import 'package:welldonatedproject/common_widgets/show_exception_alert_dialog.dart';
import 'package:welldonatedproject/services/auth.dart';
import 'package:welldonatedproject/services/database.dart';

class PubsPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
        context,
        title: 'Terminar Sessão',
        content: 'Tem a certeza que pretende terminar a sessão?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Terminar sessão');

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.setPub(Publicacao(name: 'Blogging', email: 'blogging@gmail.com', id: ''));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sair',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditPubPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Publicacao>>(
      stream: database.pubsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pubs = snapshot.data;
          final children = pubs!.map((pub) => PubListTile(
            pub: pub,
            onTap: () => EditPubPage.show(context, pub: pub),
          ))
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

}
