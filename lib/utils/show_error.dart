import 'package:flutter/material.dart';
import 'package:libero/cores.dart';

void showError(context, String message) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: const Text("Atenção", style: TextStyle(color: verdeEscuro)),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"))
          ],
        ));
