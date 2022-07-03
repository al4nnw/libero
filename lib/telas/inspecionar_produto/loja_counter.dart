import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../cores.dart';
import '../../models/atividade.dart';
import '../../models/loja.dart';
import '../../models/produto.dart';
import '../../services/database.dart';
import '../../utils/counter.dart';
import '../../utils/time_handler.dart';

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
  FocusNode focusNode = FocusNode();
  TextEditingController quantidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantidade = widget.produto.quantidade;
  }

  @override
  void dispose() {
    focusNode.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (focusNode.hasFocus) return;
        FocusScope.of(context).unfocus();
        Future(() {
          quantidadeController.value = TextEditingValue(text: quantidade.toString());
          focusNode.requestFocus();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          color: focusNode.hasFocus ? azul.withAlpha(150) : azul,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.loja.nome,
                    style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                Row(children: [
                  _buildTextField(),
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
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox.shrink(
      child: TextField(
        focusNode: focusNode,
        controller: quantidadeController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          setState(() {
            try {
              quantidade = int.parse(value);
            } catch (e) {
              quantidade = 0;
            }
          });
        },
      ),
    );
  }

  Widget _buildQuantidadeNaLoja() {
    if (focusNode.hasFocus) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(quantidade.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
      );
    }
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
