import 'package:flutter/material.dart';

import '../cores.dart';
import '../criar_produto/criar_produto.dart';
import '../main.dart';
import '../models/produto.dart';
import '../utils/time_handler.dart';
import 'produto_title.dart';

class Estoque extends StatefulWidget {
  const Estoque({Key? key}) : super(key: key);

  @override
  State<Estoque> createState() => _EstoqueState();
}

class _EstoqueState extends State<Estoque> {
  final List<Produto> produtos = [
    Produto(
        nome: "Calça Jakarta",
        quantidade: 23,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
      nome: "Calça Aparta",
      quantidade: 3,
      alteradoEm: TimeHandler.now(),
      adicionadoEm: TimeHandler.now(),
    ),
    Produto(
        nome: "Calça Listrada Carnaval",
        quantidade: 20,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
    Produto(
        nome: "Calça Bege moletom",
        quantidade: 0,
        alteradoEm: TimeHandler.now(),
        adicionadoEm: TimeHandler.now()),
  ];

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
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt))],
          title: const Text("Estoque"),
        ),
        body: Column(
          children: [
            const _FixedTitle(),
            Expanded(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: produtos.length,
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                          endIndent: 15,
                          indent: 15,
                        ),
                    itemBuilder: (context, index) => ProdutoTile(produtos[index]))),
            Container(
              color: verdeEscuro,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Total de peças",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                  Text("54 un.",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500))
                ],
              ),
            )
          ],
        ));
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