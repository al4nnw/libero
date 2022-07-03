import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cores.dart';
import '../utils/counter.dart';

enum CounterButtonType { add, subtract }

extension on Timer {
  void maybeCancel() {
    try {
      cancel();
      // ignore: empty_catches
    } catch (e) {}
  }
}

class Contador extends StatefulWidget {
  final Counter value;
  const Contador({Key? key, required this.value}) : super(key: key);

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  late Timer _timerIncrement;
  late Timer _timerDecrement;

  @override
  void dispose() {
    widget.value.removeListener(_setState);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.value.addListener(_setState);
  }

  _setState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildIcon(CounterButtonType.subtract),
        Text(widget.value.value.toString(), style: const TextStyle(fontSize: 40)),
        _buildIcon(CounterButtonType.add)
      ]),
    );
  }

  _buildIcon(CounterButtonType type) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: verdeClaro, shape: BoxShape.circle),
      child: GestureDetector(
          onTap: type == CounterButtonType.add ? widget.value.add : widget.value.sub,
          onLongPressDown: (details) {
            if (type == CounterButtonType.add) {
              _timerIncrement = Timer.periodic(const Duration(milliseconds: 100), (t) => widget.value.add());
            } else {
              _timerDecrement = Timer.periodic(const Duration(milliseconds: 100), (t) => widget.value.sub());
            }
            HapticFeedback.lightImpact();
          },
          onLongPressEnd: (details) {
            if (type == CounterButtonType.add) {
              _timerIncrement.cancel();
            } else {
              _timerDecrement.cancel();
            }
          },
          onLongPressCancel: () {
            if (type == CounterButtonType.add) {
              _timerIncrement.maybeCancel();
            } else {
              _timerDecrement.maybeCancel();
            }
          },
          child: Icon(
            type == CounterButtonType.add ? Icons.exposure_plus_1 : Icons.exposure_minus_1,
            color: Colors.white,
          )),
    );
  }
}
