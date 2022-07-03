import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/atividade.dart';
import '../models/loja.dart';
import '../models/produto.dart';
import '../utils/time_handler.dart';

const String collectionVendas = "vendas-teste";
const String collectionLojas = "lojas-teste";
const String collectionAtividades = "atividades-teste";

class Database {
  static void adicionarProduto(Produto produto) async {
    final docRef =
        FirebaseFirestore.instance.collection(collectionLojas).doc("principal").collection("produtos").doc();
    docRef.set(produto.toFirestore());
    FirebaseFirestore.instance.collection(collectionLojas)
      ..doc("concordia").collection("produtos").doc(docRef.id).set(produto.toFirestoreEmpty())
      ..doc("allBras").collection("produtos").doc(docRef.id).set(produto.toFirestoreEmpty());
  }

  static void updateEstoqueLoja(Loja loja, Produto produto, int quantidade) async {
    registrarAtividade(Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto alterado",
        subtitle: "${produto.nome} agora tem $quantidade un. no estoque da loja ${loja.nome}"));

    FirebaseFirestore.instance
        .collection(collectionLojas)
        .doc(loja.id)
        .collection("produtos")
        .doc(produto.id)
        .update({"quantidade": quantidade});
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getProducts() {
    return FirebaseFirestore.instance
        .collection(collectionLojas)
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
            .collection(collectionLojas)
            .doc("principal")
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(1)});

    /// decrementar loja
    batch.update(
        FirebaseFirestore.instance
            .collection(collectionLojas)
            .doc(loja.id)
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(-1)});

    batch.commit();
  }

  static void adicionarParaLoja(Loja loja, Produto produto) {
    final batch = FirebaseFirestore.instance.batch();

    /// decrementar armazem
    batch.update(
        FirebaseFirestore.instance
            .collection(collectionLojas)
            .doc("principal")
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(-1)});

    /// Incrementar loja
    batch.update(
        FirebaseFirestore.instance
            .collection(collectionLojas)
            .doc(loja.id)
            .collection("produtos")
            .doc(produto.id),
        {"quantidade": FieldValue.increment(1)});

    batch.commit();
  }

  static void deleteProduct(String productId) async {
    return FirebaseFirestore.instance
        .collection(collectionLojas)
        .doc("principal")
        .collection("produtos")
        .doc(productId)
        .delete();
  }

  static Stream<int> getQuantidade(String productId, {String loja = "principal"}) {
    return FirebaseFirestore.instance
        .collection(collectionLojas)
        .doc(loja)
        .collection("produtos")
        .doc(productId)
        .snapshots()
        .map((event) => event.get("quantidade"));
  }

  static void updateEstoque(String productId, int amount) async {
    if (amount < 0) return;
    return FirebaseFirestore.instance
        .collection(collectionLojas)
        .doc("principal")
        .collection("produtos")
        .doc(productId)
        .update({"quantidade": amount});
  }

  static void registrarAtividade(Atividade atividade) async {
    return FirebaseFirestore.instance.collection(collectionAtividades).doc().set(atividade.toFirestore());
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get getAtividades =>
      FirebaseFirestore.instance
          .collection(collectionAtividades)
          .orderBy("criadoEm", descending: true)
          .snapshots()
          .map((event) => event.docs);
}
