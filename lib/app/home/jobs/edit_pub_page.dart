import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/common_widgets/show_alert_dialog.dart';
import 'package:welldonatedproject/common_widgets/show_exception_alert_dialog.dart';
import 'package:welldonatedproject/services/auth.dart';
import 'package:welldonatedproject/services/database.dart';

class EditPubPage extends StatefulWidget {
  const EditPubPage({Key? key, required this.database, this.pub, required this.uid}) : super(key: key);
  final Database database;
  final Publicacao? pub;
  final String uid;

  static Future<void> show(BuildContext context, {Publicacao? pub}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPubPage(database: database, pub: pub, uid: auth.currentUser!.uid),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditPubPageState createState() => _EditPubPageState();
}

class _EditPubPageState extends State<EditPubPage> {
  final _formKey = GlobalKey<FormState>();

  String _titulo = '';
  String _quantidade = '';
  String _descricao = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    if (widget.pub != null) {
      _titulo = widget.pub!.titulo;
      _quantidade = widget.pub!.quantidade;
      _descricao = widget.pub!.descricao;
      _email = widget.pub!.name!;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final pubs = await widget.database.pubsStream().first;
        final auth = Provider.of<AuthBase>(context, listen: false);
        final allNames = pubs.map((pub) => pub.titulo).toList();
        if (widget.pub != null) {
          allNames.remove(widget.pub!.titulo);
        }
        if (allNames.contains(_titulo)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK', cancelActionText: '',
          );
        } else {
          final id = widget.pub?.id ?? documentIdFromCurrentDate();
          final pub = Publicacao(id: id, titulo: _titulo, quantidade: _quantidade, descricao: _descricao, uid: auth.currentUser!.uid, name: auth.currentUser!.email);
          await widget.database.setPub(pub);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.pub == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Titulo'),
        initialValue: _titulo,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _titulo = value!,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Quantidade'),
        initialValue: _quantidade != null ? '$_quantidade' : null,
        keyboardType: TextInputType.number,
        onSaved: (value) => _quantidade = value!,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Descricao'),
        initialValue: _descricao,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _descricao = value!,
      ),
      SizedBox(height: 12.0),
      Text(widget.pub == null ? '' : 'Criado por: $_email'),
    ];
  }
}