import 'package:flutter/material.dart';
import 'package:libero/componentes/contador.dart';

import '../cores.dart';
import '../models/produto.dart';
import '../services/database.dart';
import '../utils/counter.dart';
import '../utils/show_error.dart';
import '../utils/time_handler.dart';

class CriarProduto extends StatefulWidget {
  const CriarProduto({Key? key}) : super(key: key);

  @override
  State<CriarProduto> createState() => _CriarProdutoState();
}

class _CriarProdutoState extends State<CriarProduto> {
  final nomeController = TextEditingController();
  final counter = Counter(0, min: 0);

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: verdeClaro,
          elevation: 0,
          leading:
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("Estoque"),
        ),
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: cinza, borderRadius: BorderRadius.all(Radius.circular(5))),
                      height: 250,
                      width: 250,
                      child: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.camera_alt, color: verdeEscuro, size: 30)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Nome do produto",
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(hintText: "Digite o nome do produto"),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Quantidade no estoque",
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),
                  Contador(value: counter)
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: verdeEscuro,
            splashColor: Colors.transparent,
            onPressed: _onCreateProduct,
            child: const Icon(Icons.check, color: Colors.white)));
  }

  void _onCreateProduct() {
    /// Verificar se campos foram preenchidos
    if (nomeController.value.text == "") {
      return showError(context, "Insira o nome do produto.");
    }

    /// Adicionar ao firestore
    Database.adicionarProduto(Produto(
        nome: nomeController.value.text,
        quantidade: counter.value,
        adicionadoEm: TimeHandler.now(),
        alteradoEm: TimeHandler.now()));

    Navigator.pop(context);
  }
}
