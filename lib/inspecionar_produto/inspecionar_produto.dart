import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libero/componentes/contador.dart';
import 'package:libero/estoque/estoque.dart';
import 'package:libero/models/atividade.dart';

import '../cores.dart';
import '../models/loja.dart';
import '../models/produto.dart';
import '../services/database.dart';
import '../utils/counter.dart';
import '../utils/time_handler.dart';

class InspecionarProduto extends ConsumerStatefulWidget {
  final Produto produto;
  const InspecionarProduto({Key? key, required this.produto}) : super(key: key);

  @override
  ConsumerState<InspecionarProduto> createState() => _InspecionarProdutoState();
}

class _InspecionarProdutoState extends ConsumerState<InspecionarProduto> {
  bool _showContadorEstoque = false;

  bool podeRegistrarAlteracaoEstoque = true;

  late Counter counterEstoque;
  @override
  void initState() {
    super.initState();
    counterEstoque = Counter(widget.produto.quantidade);
    counterEstoque.addListener(_atualizarProduto);
  }

  @override
  void dispose() {
    counterEstoque.removeListener(_atualizarProduto);
    counterEstoque.dispose();
    super.dispose();
  }

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
        actions: [IconButton(onPressed: deleteProduct, icon: const Icon(Icons.delete))],
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
                children: [
                  const Text("Quantidade no estoque",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  QuantidadeProduto(
                    produto: widget.produto,
                  ),
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
              secondChild: _ContadoresLojas(
                produto: widget.produto,
                counter: counterEstoque,
              ),
              crossFadeState: _showContadorEstoque ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            )
          ],
        ),
      ),
    );
  }

  void _atualizarProduto() {
    if (podeRegistrarAlteracaoEstoque) {
      int quantidadeInicio = counterEstoque.value;

      podeRegistrarAlteracaoEstoque = false;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        final int difference = counterEstoque.value - quantidadeInicio;

        if (difference == 0) return;
        String title = "";
        String subtitle = "";
        if (difference > 0) {
          title = "Produto reabastecido";
          subtitle = "$difference unidades de ${widget.produto.nome} adicionadas ao estoque";
        } else {
          title = "Produto removido";
          subtitle = "$difference unidades de ${widget.produto.nome} removidas do estoquye";
        }
        Database.registrarAtividade(Atividade(criadoEm: TimeHandler.now(), title: title, subtitle: subtitle));
        podeRegistrarAlteracaoEstoque = true;
      });
    }
    Database.updateEstoque(widget.produto.id, counterEstoque.value);
  }

  void deleteProduct() {
    Database.deleteProduct(widget.produto.id);
    ref.refresh(productsCounter);
    Navigator.pop(context);
  }
}

class QuantidadeProduto extends StatelessWidget {
  final Produto produto;
  const QuantidadeProduto({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = "${produto.quantidade.toString()} un.";
    return StreamBuilder<int>(
        stream: Database.getQuantidade(produto.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            text = "${snapshot.data.toString()} un.";
          }

          return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
        });
  }
}

class _ContadoresLojas extends StatelessWidget {
  final Produto produto;
  final Counter counter;
  const _ContadoresLojas({
    Key? key,
    required this.produto,
    required this.counter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LojaCounter(
            loja: Loja(nome: "Concórdia", funcional: true, id: "concordia"),
            produto: produto,
            counterEstoqueArmazem: counter),
        LojaCounter(
            loja: Loja(nome: "All Brás", funcional: true, id: "allBras"),
            produto: produto,
            counterEstoqueArmazem: counter)
      ],
    );
  }
}

/// Total de unidades deste item que a loja possui
class LojaCounter extends StatefulWidget {
  final Loja loja;
  final Counter counterEstoqueArmazem;
  final Produto produto;
  const LojaCounter({
    Key? key,
    required this.loja,
    required this.produto,
    required this.counterEstoqueArmazem,
  }) : super(key: key);

  @override
  State<LojaCounter> createState() => _LojaCounterState();
}

class _LojaCounterState extends State<LojaCounter> {
  int quantidade = 0;

  bool podeRegistrarDecremento = true;
  bool podeRegistrarIncremento = true;

  @override
  void initState() {
    super.initState();
    quantidade = widget.produto.quantidade;
  }

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
              Text(widget.loja.nome,
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
              Row(children: [
                IconButton(
                    splashRadius: 0.01,
                    onPressed: () {
                      /// Verificar se esta acumulando
                      if (quantidade <= 0) return;
                      if (podeRegistrarIncremento) {
                        quantidade--;
                        _registrarAtividadeDecrementar();
                        Database.retirarDaLoja(widget.loja, widget.produto);
                        widget.counterEstoqueArmazem.value++;
                      }
                    },
                    icon: const Icon(
                      Icons.exposure_minus_1,
                      color: Colors.white,
                    )),
                const SizedBox(width: 5),
                _buildQuantidadeNaLoja(),
                const SizedBox(width: 5),
                IconButton(
                    splashRadius: 0.01,
                    onPressed: () {
                      /// Verificar se esta acumulando
                      if (widget.counterEstoqueArmazem.value > 0 && podeRegistrarDecremento) {
                        _registrarAtividadeIncrementar();
                        Database.adicionarParaLoja(widget.loja, widget.produto);
                        widget.counterEstoqueArmazem.value--;
                      }
                    },
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

  Widget _buildQuantidadeNaLoja() {
    return StreamBuilder<int>(
        stream: Database.getQuantidade(widget.produto.id, loja: widget.loja.id),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            quantidade = snapshot.data!;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(quantidade.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
          );
        });
  }

  void _registrarAtividadeDecrementar() {
    if (podeRegistrarDecremento) {
      int quantidadeInicio = widget.counterEstoqueArmazem.value;
      podeRegistrarDecremento = false;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        Database.registrarAtividade(Atividade(
            criadoEm: TimeHandler.now(),
            title: "Produto transferido",
            subtitle:
                "${widget.counterEstoqueArmazem.value - quantidadeInicio} unidades de ${widget.produto.nome} para o estoque."));
        podeRegistrarDecremento = true;
      });
    }
  }

  void _registrarAtividadeIncrementar() {
    if (podeRegistrarIncremento) {
      int quantidadeInicio = widget.counterEstoqueArmazem.value;
      podeRegistrarIncremento = false;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        Database.registrarAtividade(Atividade(
            criadoEm: TimeHandler.now(),
            title: "Produto transferido",
            subtitle:
                "${quantidadeInicio - widget.counterEstoqueArmazem.value} unidades de ${widget.produto.nome} para ${widget.loja.nome}."));
        podeRegistrarIncremento = true;
      });
    }
  }
}
