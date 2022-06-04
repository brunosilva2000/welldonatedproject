
class Publicacao {
  Publicacao({required this.id, required this.name, required this.email});
  final String id;
  final String name;
  final String email;

  factory Publicacao.fromMap(Map<String, dynamic> data, String documentId) {
    assert(data != null, 'data must not be null');

    final String name = data['name'];
    final String email = data['email'];
    return Publicacao(
        id: documentId,
        name: name,
        email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
