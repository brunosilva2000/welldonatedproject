import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welldonatedproject/app/home/models/publicacao.dart';
import 'package:welldonatedproject/services/api_path.dart';
import 'package:welldonatedproject/services/firestore_service.dart';

abstract class Database {
  Future<void> setPub(Publicacao pub);
  Stream<List<Publicacao>> pubsStream();
  Future<void> deletePost(String? postId);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setPub(Publicacao pub) => _service.setData(
    //path: APIPath.pub(uid, pub.id),
    path: APIPath.post(pub.id),
    data: pub.toMap(),
  );

  Stream<List<Publicacao>> pubsStream() => _service.collectionStream(
    //path: APIPath.pubs(uid),
    path: APIPath.posts(),
    builder: (data, documentId) => Publicacao.fromMap(data, documentId),
  );

  Future<void> deletePost(String? postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
  }
}
