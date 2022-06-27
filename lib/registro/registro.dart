import 'package:flutter/material.dart';

import '../cores.dart';
import '../models/atividade.dart';
import '../utils/time_handler.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final List<Atividade> registro = [
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
    Atividade(
        criadoEm: TimeHandler.now(),
        title: "Produto Tranferido",
        subtitle: "Calça Jakarta - 50 unidades para Concórdia."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: verdeClaro,
          elevation: 0,
          leading: null,
          centerTitle: true,
          title: const Text("Registro"),
        ),
        body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (context, index) => AtividadeTile(
                  atividade: registro[index],
                ),
            separatorBuilder: (context, index) => const Divider(color: Colors.black, thickness: 1),
            itemCount: registro.length));
  }
}

class AtividadeTile extends StatelessWidget {
  final Atividade atividade;
  const AtividadeTile({
    Key? key,
    required this.atividade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(atividade.title,
              style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(atividade.subtitle), Text(atividade.criadoEm.toDelta())],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
