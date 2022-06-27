class Loja {
  final String nome;

  /// id do documento na coleção lojas
  final String id;

  /// Se loja é ponto de venda ou estoque
  final bool funcional;

  Loja({required this.nome, required this.id, required this.funcional});

  Loja.fromFirestore(Map lojaMap, this.id)
      : nome = lojaMap["nome"],
        funcional = lojaMap["funcional"];
}
