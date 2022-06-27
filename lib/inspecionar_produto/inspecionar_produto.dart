import 'package:flutter/material.dart';
import 'package:libero/componentes/contador.dart';

import '../cores.dart';
import '../models/loja.dart';
import '../models/produto.dart';
import '../utils/counter.dart';

class InspecionarProduto extends StatefulWidget {
  final Produto produto;
  const InspecionarProduto({Key? key, required this.produto}) : super(key: key);

  @override
  State<InspecionarProduto> createState() => _InspecionarProdutoState();
}

class _InspecionarProdutoState extends State<InspecionarProduto> {
  bool _showContadorEstoque = false;
  final counterEstoque = Counter(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          elevation: 3,
          backgroundColor: verdeClaro,
          onPressed: () {
            setState(() {
              _showContadorEstoque = !_showContadorEstoque;
            });
          },
          child: Icon(_showContadorEstoque ? Icons.close : Icons.add)),
      appBar: AppBar(
        backgroundColor: verdeClaro,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
        title: const Text("Estoque"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration:
                  const BoxDecoration(color: cinza, borderRadius: BorderRadius.all(Radius.circular(5))),
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            Text(widget.produto.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Quantidade no estoque",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  Text("23 un.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
              height: 25,
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Contador(value: counterEstoque),
              ),
              secondChild: const _ContadoresLojas(),
              crossFadeState: _showContadorEstoque ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            )
          ],
        ),
      ),
    );
  }
}

class _ContadoresLojas extends StatelessWidget {
  const _ContadoresLojas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LojaCounter(loja: Loja(nome: "Concórdia", funcional: true, id: ""), quantidade: 60),
        LojaCounter(loja: Loja(nome: "Concórdia", funcional: true, id: ""), quantidade: 60)
      ],
    );
  }
}

/// Total de unidades deste item que a loja possui
class LojaCounter extends StatelessWidget {
  final Loja loja;
  final int quantidade;
  const LojaCounter({
    Key? key,
    required this.loja,
    required this.quantidade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: azul,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loja.nome,
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
              Row(children: [
                IconButton(
                    splashRadius: 0.01,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.exposure_minus_1,
                      color: Colors.white,
                    )),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(quantidade.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 5),
                IconButton(
                    splashRadius: 0.01,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.exposure_plus_1,
                      color: Colors.white,
                    )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
