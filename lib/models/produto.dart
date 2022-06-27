import '../utils/time_handler.dart';

class Produto {
  final String nome;
  final int quantidade;
  final String? foto;
  final TimeHandler adicionadoEm;
  final TimeHandler alteradoEm;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.adicionadoEm,
    required this.alteradoEm,
    this.foto,
  });

  Produto.fromFirestore(Map produtoMap)
      : nome = produtoMap["nome"],
        quantidade = produtoMap["quantidade"],
        adicionadoEm = TimeHandler(produtoMap["adicionadoEm"]),
        alteradoEm = TimeHandler(produtoMap["alteradoEm"]),
        foto = produtoMap["foto"];

  Map<String, Object?> toFirestore() {
    return {
      "nome": nome,
      "quantidade": quantidade,
      "adicionadoEm": adicionadoEm.toString(),
      "alteradoEm": alteradoEm.toString(),
      "foto": foto,
    };
  }
}
