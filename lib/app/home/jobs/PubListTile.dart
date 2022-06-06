import 'package:flutter/material.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';

class PubListTile extends StatelessWidget {
  const PubListTile({Key? key, required this.pub, this.onTap}) : super(key: key);
  final Publicacao pub;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pub.titulo),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}