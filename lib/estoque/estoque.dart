import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libero/models/total_products_store.dart';

import '../cores.dart';
import '../criar_produto/criar_produto.dart';
import '../main.dart';
import '../models/produto.dart';
import '../services/database.dart';
import 'escolher_filtros.dart';
import 'produto_title.dart';

final productsCounter = ChangeNotifierProvider<TotalProductsStore>((ref) => TotalProductsStore());

class Estoque extends StatelessWidget {
  const Estoque({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton(
              splashColor: Colors.transparent,
              elevation: 3,
              backgroundColor: verdeClaro,
              onPressed: () {
                rootNavigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (context) => const CriarProduto()));
              },
              child: const Icon(Icons.add)),
        ),
        appBar: AppBar(
          backgroundColor: verdeClaro,
          elevation: 0,
          leading:
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) => const EscolherFiltros());
                },
                icon: const Icon(Icons.filter_alt))
          ],
          title: const Text("Estoque"),
        ),
        body: Column(
          children: [
            const _FixedTitle(),
            Expanded(
                child: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    stream: Database.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return _ProductsList(produtos: snapshot.data!);
                      }
                      return const Center(
                        child: Text("Nenhum produto foi encontrado."),
                      );
                    })),
            const _TotalProducsCount()
          ],
        ));
  }
}

class _TotalProducsCount extends ConsumerWidget {
  const _TotalProducsCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final value = ref.watch(productsCounter).total;

    return Container(
      color: verdeEscuro,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total de peças",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
          Text("$value un.",
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({
    Key? key,
    required this.produtos,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> produtos;

  @override
  Widget build(BuildContext context) {
    if (produtos.isEmpty) {
      return _ifEmpty();
    }
    return ListView.separated(
        cacheExtent: 2000,
        physics: const BouncingScrollPhysics(),
        itemCount: produtos.length,
        separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
              endIndent: 15,
              indent: 15,
            ),
        itemBuilder: (context, index) =>
            ProdutoTile(Produto.fromFirestore(produtos[index].data(), produtos[index].id)));
  }

  Widget _ifEmpty() {
    return const Center(
      child: Text("Nenhum produto foi adicionado ainda."),
    );
  }
}

class _FixedTitle extends StatelessWidget {
  const _FixedTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Nome do produto", style: TextStyle(fontSize: 16)),
              Text("Qtde", style: TextStyle(fontSize: 16))
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Divider(
          thickness: 1,
          height: 0,
          color: Colors.black,
        )
      ],
    );
  }
}
