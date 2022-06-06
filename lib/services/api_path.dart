
class APIPath {
  static String pub(String uid, String jobId) => 'Pessoal/$uid/Publicação/$jobId';
  static String pubs(String uid) => 'Pessoal/$uid/Publicação';
  static String post(String jobId) => 'posts/$jobId';
  static String posts() => 'posts';
}