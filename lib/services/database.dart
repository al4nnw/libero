import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/produto.dart';

class Database {
  static void adicionarProduto(Produto produto) async {
    FirebaseFirestore.instance.collection("lojas")
      ..doc("principal").collection("produtos").doc().set(produto.toFirestore())
      ..doc("concordia").collection("produtos").doc().set(produto.toFirestoreEmpty())
      ..doc("allBras").collection("produtos").doc().set(produto.toFirestoreEmpty());
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getProducts() {
    return FirebaseFirestore.instance
        .collection("lojas")
        .doc("principal")
        .collection("produtos")
        .snapshots()
        .map((event) => event.docs)
        .asBroadcastStream();
  }

  static void deleteProduct(String productId) async {
    return FirebaseFirestore.instance
        .collection("lojas")
        .doc("principal")
        .collection("produtos")
        .doc(productId)
        .delete();
  }

  static Stream<int> getQuantidade(String productId, {String loja = "principal"}) {
    return FirebaseFirestore.instance
        .collection("lojas")
        .doc(loja)
        .collection("produtos")
        .doc(productId)
        .snapshots()
        .map((event) => event.get("quantidade"));
  }

  static void updateEstoque(String productId, int amount) async {
    return FirebaseFirestore.instance
        .collection("lojas")
        .doc("principal")
        .collection("produtos")
        .doc(productId)
        .update({"quantidade": amount});
  }
}
