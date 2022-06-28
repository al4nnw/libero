import 'package:intl/intl.dart';

class TimeHandler extends DateTime {
  TimeHandler._(int _millisecondsSinceEpoch) : super.fromMillisecondsSinceEpoch(_millisecondsSinceEpoch);

  factory TimeHandler(untypedDate) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(untypedDate);
    } catch (e) {
      if (untypedDate is int) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(untypedDate * 1000);
      } else {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(untypedDate.millisecondsSinceEpoch);
      }
    }

    return TimeHandler._(parsedDate.millisecondsSinceEpoch);
  }

  factory TimeHandler.now() => TimeHandler._(DateTime.now().millisecondsSinceEpoch);

  /// Retorna uma [String] com uma representação `dd-MM-yyyy` deste objeto.
  String toDate() {
    return DateFormat("dd-MM-yyyy").format(this);
  }

  /// Retorna uma [String] com uma representação de quanto tempo já passou de certa data até agora.
  String toDelta() {
    final delta = DateTime.now().difference(this);

    if (delta.inDays > 0 && delta.inDays <= 7) return "${delta.inDays}d";

    if (delta.inHours > 0 && delta.inDays < 1) return "${delta.inHours}h";

    if (delta.inMinutes > 0 && delta.inHours < 1) return "${delta.inMinutes}m";

    if (delta.inSeconds > 0 && delta.inMinutes < 1) return "${delta.inSeconds}s";

    return "0s";
  }

  String toDateComHoras() {
    return "${DateFormat("dd-MM-yyyy").format(this)} às ${DateFormat("Hm").format(this)}";
  }
}
