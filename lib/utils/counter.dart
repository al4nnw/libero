import 'package:flutter/foundation.dart';

class Counter extends ChangeNotifier {
  int? max;
  int? min;
  bool enabled;
  int value;
  Counter(this.value, {this.max, this.min, this.enabled = true});

  void add() {
    enabled = true;
    if (value == max) return;
    value++;
    notifyListeners();
  }

  void sub() {
    enabled = true;
    if (value == min) return;
    value--;
    notifyListeners();
  }

  void clear() {
    value = 0;
    enabled = false;

    notifyListeners();
  }
}
