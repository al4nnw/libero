import 'package:flutter/foundation.dart';

class Counter extends ValueNotifier<int> {
  int? max;
  int? min;
  bool enabled;
  Counter(super.value, {this.max, this.min, this.enabled = true});

  void add() {
    enabled = true;
    if (value == max) return;
    value++;
  }

  void sub() {
    enabled = true;
    if (value == min) return;
    value--;
  }

  void clear() {
    value = 0;
    enabled = false;

    notifyListeners();
  }
}
