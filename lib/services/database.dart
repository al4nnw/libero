import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/produto.dart';

class Database {
  static void adicionarProduto(Produto produto) async {
    FirebaseFirestore.instance
        .collection("lojas")
        .doc("principal")
        .collection("produtos")
        .doc()
        .set(produto.toFirestore());
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getProducts() {
    return FirebaseFirestore.instance
        .collection("lojas")
        .doc("principal")
        .collection("produtos")
        .snapshots()
        .map((event) => event.docs);
  }
}
