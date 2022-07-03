import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libero/cores.dart';
import 'package:libero/models/atividade.dart';
import 'package:libero/services/database.dart';

class UltimasAtividades extends StatefulWidget {
  const UltimasAtividades({Key? key}) : super(key: key);

  @override
  State<UltimasAtividades> createState() => _UltimasAtividadesState();
}

class _UltimasAtividadesState extends State<UltimasAtividades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: verdeClaro,
          elevation: 0,
          leading: null,
          centerTitle: true,
          title: const Text("Últimas atividades"),
        ),
        body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            stream: Database.getAtividades,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (snapshot.hasData && data != null) {
                final atividades = data;

                if (data.isEmpty) {
                  return _buildIfEmpty();
                }

                return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20),
                    itemBuilder: (context, index) => AtividadeTile(
                          atividade: Atividade.fromFirestore(atividades[index].data()),
                        ),
                    separatorBuilder: (context, index) => const Divider(color: Colors.black, thickness: 1),
                    itemCount: atividades.length);
              }

              return _buildIfEmpty();
            }));
  }

  Widget _buildIfEmpty() {
    return const Center(
      child: Text("Nenhuma atividade encontrada"),
    );
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
            children: [Expanded(child: Text(atividade.subtitle)), _SelfUpdateTime(atividade: atividade)],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _SelfUpdateTime extends StatefulWidget {
  const _SelfUpdateTime({
    Key? key,
    required this.atividade,
  }) : super(key: key);

  final Atividade atividade;

  @override
  State<_SelfUpdateTime> createState() => _SelfUpdateTimeState();
}

class _SelfUpdateTimeState extends State<_SelfUpdateTime> {
  late Timer selfUpdate;
  late bool shouldSelfUpdate;
  @override
  void initState() {
    super.initState();
    shouldSelfUpdate = widget.atividade.criadoEm.difference(DateTime.now()).inMinutes < 60;
    if (shouldSelfUpdate) {
      print("true");
      selfUpdate = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (shouldSelfUpdate) selfUpdate.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.atividade.criadoEm.toDelta());
  }
}
