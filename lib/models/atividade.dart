import '../utils/time_handler.dart';

class Atividade {
  final TimeHandler criadoEm;
  final String title;
  final String subtitle;

  Atividade({required this.criadoEm, required this.title, required this.subtitle});

  Atividade.fromFirestore(Map atividadeMap)
      : title = atividadeMap["title"],
        subtitle = atividadeMap["subtitle"],
        criadoEm = TimeHandler(atividadeMap["criadoEm"]);

  Map<String, Object?> toFirestore() {
    return {"title": title, "subtitle": subtitle, "criadoEm": criadoEm.toString()};
  }
}
