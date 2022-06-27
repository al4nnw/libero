import 'package:flutter/material.dart';

import '../models/produto.dart';

class InspecionarProduto extends StatelessWidget {
  final Produto produto;
  const InspecionarProduto({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(produto.nome)),
    );
  }
}
