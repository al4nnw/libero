import 'package:flutter/material.dart';

import '../../cores.dart';

class EscolherFiltros extends StatefulWidget {
  const EscolherFiltros({
    Key? key,
  }) : super(key: key);

  @override
  State<EscolherFiltros> createState() => _EscolherFiltrosState();
}

class _EscolherFiltrosState extends State<EscolherFiltros> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("Mostrando estoque do", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          const _LojaToFilter(title: "Armazém", selected: true),
          const _LojaToFilter(title: "Concórdia", selected: false),
          const _LojaToFilter(title: "All Brás", selected: false),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"))
        ]),
      ),
    );
  }
}

class _LojaToFilter extends StatelessWidget {
  final String title;
  final bool selected;
  const _LojaToFilter({
    Key? key,
    required this.selected,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinza,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
              )),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
            child: Center(
              child: Container(
                height: 14,
                width: 14,
                decoration:
                    BoxDecoration(color: selected ? verdeEscuro : Colors.transparent, shape: BoxShape.circle),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
