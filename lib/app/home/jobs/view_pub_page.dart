import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/common_widgets/show_alert_dialog.dart';
import 'package:welldonatedproject/common_widgets/show_exception_alert_dialog.dart';
import 'package:welldonatedproject/services/auth.dart';
import 'package:welldonatedproject/services/database.dart';

class ViewPubPage extends StatefulWidget {
  const ViewPubPage({Key? key, required this.database, this.pub, required this.uid}) : super(key: key);
  final Database database;
  final Publicacao? pub;
  final String uid;

  static Future<void> show(BuildContext context, {Publicacao? pub}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewPubPage(database: database, pub: pub, uid: auth.currentUser!.uid),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _ViewPubPageState createState() => _ViewPubPageState();
}

class _ViewPubPageState extends State<ViewPubPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.pub == null ? 'Novo anúncio' : 'Editar anúncio'),
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
        decoration: InputDecoration(labelText: 'Título'),
        initialValue: _titulo,
        validator: (value) => value!.isNotEmpty ? null : 'Campo obrigatório!',
        onSaved: (value) => _titulo = value!,
        readOnly: true,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Quantidade'),
        initialValue: _quantidade != null ? '$_quantidade' : null,
        keyboardType: TextInputType.number,
        validator: (value) => value!.isNotEmpty ? null : 'Campo obrigatório!',
        onSaved: (value) => _quantidade = value!,
        readOnly: true,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Descrição'),
        initialValue: _descricao,
        validator: (value) => value!.isNotEmpty ? null : 'Campo obrigatório!',
        onSaved: (value) => _descricao = value!,
        readOnly: true,
      ),
      SizedBox(height: 12.0),
      Text('Criado por: $_email'),
    ];
  }
}
