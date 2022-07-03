import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libero/rotas.dart';

import '../../cores.dart';
import '../../models/produto.dart';
import 'estoque.dart';

class ProdutoTile extends ConsumerWidget {
  final Produto produto;
  const ProdutoTile(
    this.produto, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    Future.delayed(Duration.zero, () => ref.read(productsCounter.notifier).updateKey(produto));
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(Rotas.inspecionarProduto, arguments: produto);
      },
      trailing: Text(produto.quantidade.toString(), style: const TextStyle(fontSize: 16)),
      leading: Container(
        height: 70,
        width: 70,
        decoration: const BoxDecoration(color: cinza, borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      title: Text(produto.nome),
      subtitle: Text("Adicionado em ${produto.adicionadoEm.toDate()}"),
    );
  }
}
