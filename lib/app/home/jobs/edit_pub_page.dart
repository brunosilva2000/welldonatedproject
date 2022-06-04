import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/common_widgets/show_alert_dialog.dart';
import 'package:welldonatedproject/common_widgets/show_exception_alert_dialog.dart';
import 'package:welldonatedproject/services/database.dart';

class EditPubPage extends StatefulWidget {
  const EditPubPage({Key? key, required this.database, this.pub}) : super(key: key);
  final Database database;
  final Publicacao? pub;

  static Future<void> show(BuildContext context, {Publicacao? pub}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPubPage(database: database, pub: pub),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditPubPageState createState() => _EditPubPageState();
}

class _EditPubPageState extends State<EditPubPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    if (widget.pub != null) {
      _name = widget.pub!.name;
      _email = widget.pub!.email;
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
        final jobs = await widget.database.pubsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.pub != null) {
          allNames.remove(widget.pub!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK', cancelActionText: '',
          );
        } else {
          final id = widget.pub?.id ?? documentIdFromCurrentDate();
          final pub = Publicacao(id: id, name: _name, email: _email);
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
        decoration: InputDecoration(labelText: 'Name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        initialValue: _email != null ? '$_email' : null,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value!,
      ),
    ];
  }
}
