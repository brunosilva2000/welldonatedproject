import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/services/api_path.dart';
import 'package:welldonatedproject/services/firestore_service.dart';

abstract class Database {
  Future<void> setPub(Publicacao pub);
  Stream<List<Publicacao>> pubsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setPub(Publicacao pub) => _service.setData(
    path: APIPath.pub(uid, pub.id),
    data: pub.toMap(),
  );

  Stream<List<Publicacao>> pubsStream() => _service.collectionStream(
    path: APIPath.pubs(uid),
    builder: (data, documentId) => Publicacao.fromMap(data, documentId),
  );
}
