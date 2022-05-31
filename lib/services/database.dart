import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:welldonatedproject/app/home/models/job.dart';
import 'package:welldonatedproject/services/api_path.dart';
import 'package:welldonatedproject/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> createJob(Job job) => _service.setData(
    path: APIPath.job(uid, 'job_abc'),
    data: job.toMap(),
  );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data) => Job.fromMap(data),
  );

}
