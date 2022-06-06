
class Publicacao {
  Publicacao({required this.id, required this.titulo, required this.quantidade, required this.descricao, required this.uid, required this.name});
  final String id;
  final String titulo;
  final String quantidade;
  final String descricao;
  final String? uid;
  final String? name;

  factory Publicacao.fromMap(Map<String, dynamic> data, String documentId) {
    assert(data != null, 'data must not be null');

    final String titulo = data['titulo'];
    final String quant = data['quantidade'];
    final String descr = data['descricao'];
    final String? uid = data['uid'];
    final String? name = data['name'];
    return Publicacao(
        id: documentId,
        titulo: titulo,
        quantidade: quant,
        descricao: descr,
        uid: uid,
        name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'quantidade': quantidade,
      'descricao': descricao,
      'uid': uid,
      'name': name,
    };
  }
}
