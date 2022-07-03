import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libero/componentes/contador.dart';

import '../../cores.dart';
import '../../models/loja.dart';
import '../../models/produto.dart';
import '../../services/database.dart';
import '../../utils/counter.dart';
import '../estoque/estoque.dart';
import 'loja_counter.dart';

class InspecionarProduto extends ConsumerStatefulWidget {
  final Produto produto;
  const InspecionarProduto({Key? key, required this.produto}) : super(key: key);

  @override
  ConsumerState<InspecionarProduto> createState() => _InspecionarProdutoState();
}

class _InspecionarProdutoState extends ConsumerState<InspecionarProduto> {
  bool _showContadorEstoque = false;
  FocusNode focusNodeArmazem = FocusNode();
  TextEditingController armazemController = TextEditingController();

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
    focusNodeArmazem.dispose();
    armazemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            splashColor: Colors.transparent,
            elevation: 3,
            backgroundColor: verdeClaro,
            onPressed: () {
              setState(() {
                _showContadorEstoque = !_showContadorEstoque;
                if (!_showContadorEstoque) {
                  focusNodeArmazem.unfocus();
                }
              });
            },
            child: Icon(_showContadorEstoque ? Icons.close : Icons.add)),
        appBar: AppBar(
          backgroundColor: verdeClaro,
          elevation: 0,
          leading:
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          actions: [IconButton(onPressed: deleteProduct, icon: const Icon(Icons.delete))],
          title: const Text("Estoque"),
        ),
        body: SingleChildScrollView(
          reverse: true,
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
                    _buildQuantidadeArmazem()
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
                  child: GestureDetector(
                    onTap: () {
                      focusNodeArmazem.requestFocus();
                    },
                    child: Column(
                      children: [
                        Contador(value: counterEstoque),
                        _buildTextField(),
                      ],
                    ),
                  ),
                ),
                secondChild: _ContadoresLojas(
                  produto: widget.produto,
                  counter: counterEstoque,
                ),
                crossFadeState: _showContadorEstoque ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox.shrink(
      child: TextField(
        focusNode: focusNodeArmazem,
        controller: armazemController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          setState(() {
            try {
              counterEstoque.value = int.parse(value);
            } catch (e) {
              counterEstoque.value = 0;
            }
          });
        },
        onSubmitted: (value) {
          _atualizarProduto();
        },
      ),
    );
  }

  Widget _buildQuantidadeArmazem() {
    String text = "${widget.produto.quantidade.toString()} un.";
    if (focusNodeArmazem.hasFocus) {
      text = "${counterEstoque.value} un.";
      return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
    }
    return StreamBuilder<int>(
        stream: Database.getQuantidade(widget.produto.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            text = "${snapshot.data.toString()} un.";
            counterEstoque.value = snapshot.data!;
          }
          return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
        });
  }

  void _atualizarProduto() {
    Database.updateEstoque(widget.produto.id, counterEstoque.value);
  }

  void deleteProduct() {
    Database.deleteProduct(widget.produto.id);
    ref.refresh(productsCounter);
    Navigator.pop(context);
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
