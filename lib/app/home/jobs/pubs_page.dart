import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/home/jobs/PubListTile.dart';
import 'package:welldonatedproject/app/home/jobs/edit_pub_page.dart';
import 'package:welldonatedproject/app/home/jobs/view_pub_page.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/common_widgets/show_alert_dialog.dart';
import 'package:welldonatedproject/services/auth.dart';
import 'package:welldonatedproject/services/database.dart';

class PubsPage extends StatelessWidget {
  final String uid;

  const PubsPage({Key? key, required this.uid}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Terminar Sessão',
        content: 'Tem a certeza que pretende terminar a sessão?',
        cancelActionText: 'Cancelar',
        defaultActionText: 'Terminar sessão');

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _verifyId(BuildContext context, Publicacao pub) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    if (auth.currentUser!.uid == pub.uid) {
      EditPubPage.show(context, pub: pub);
    } else {
      ViewPubPage.show(context, pub: pub);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
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
      floatingActionButton: auth.currentUser?.email == null
          ? null
          : FloatingActionButton(
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
          final children = pubs!
              .map((pub) => PubListTile(
                    pub: pub,
                    onTap: () => _verifyId(context, pub),
                  ))
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ocorreu um erro'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
