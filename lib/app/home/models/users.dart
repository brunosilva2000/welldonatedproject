class Users {
  Users({required this.uid, required this.email, required this.username, required this.morada, required this.contacto});
  final String uid;
  final String email;
  final String username;
  final String morada;
  final String contacto;

  factory Users.fromMap(Map<String, dynamic> data, String documentId) {
    assert(data != null, 'data must not be null');

    final String uid = data['uid'];
    final String username = data['username'];
    final String email = data['email'];
    final String morada = data['morada'];
    final String contacto = data['contacto'];
    return Users(
      uid: uid,
      username: username,
      email: email,
      morada: morada,
      contacto: contacto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'morada': morada,
      'contacto': contacto,
    };
  }
}