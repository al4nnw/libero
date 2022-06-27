import 'package:flutter/foundation.dart';
import 'package:libero/models/produto.dart';

class TotalProductsStore extends ChangeNotifier {
  final Map<String, int> _total = {};

  TotalProductsStore();

  int get total {
    int soma = 0;

    _total.forEach((key, value) {
      soma += value;
    });

    return soma;
  }

  void updateKey(Produto produto) {
    _total[produto.id] = produto.quantidade;

    notifyListeners();
  }
}
