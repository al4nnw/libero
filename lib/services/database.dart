import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loja.dart';
import '../models/produto.dart';

class Database {
  static void adicionarProduto(Produto produto) async {
    final docRef =
        FirebaseFirestore.instance.collection("lojas").doc("principal").collection("produtos").doc();
    docRef.set(produto.toFirestore());
    FirebaseFirestore.instance.collection("lojas")
      ..doc("concordia").collection("produtos").doc(docRef.id).set(produto.toFirestoreEmpty())
      ..doc("allBras").collection("produtos").doc(docRef.id).set(produto.toFirestoreEmpty());
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

  static void retirarDaLoja(Loja loja, Produto produto) async {
    final batch = FirebaseFirestore.instance.batch();

    /// Incrementar armazem
    batch.update(
        FirebaseFirestore.instance
            .collection("lojas")
            .doc("principal")
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(1)});

    /// decrementar loja
    batch.update(
        FirebaseFirestore.instance.collection("lojas").doc(loja.id).collection("produtos").doc(produto.id),
        {"quantidade": FieldValue.increment(-1)});

    batch.commit();
  }

  static void adicionarParaLoja(Loja loja, Produto produto) {
    final batch = FirebaseFirestore.instance.batch();

    /// decrementar armazem
    batch.update(
        FirebaseFirestore.instance
            .collection("lojas")
            .doc("principal")
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(-1)});

    /// Incrementar loja
    batch.update(
        FirebaseFirestore.instance.collection("lojas").doc(loja.id).collection("produtos").doc(produto.id),
        {"quantidade": FieldValue.increment(1)});

    batch.commit();
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
