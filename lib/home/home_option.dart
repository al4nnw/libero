import 'package:flutter/material.dart';

class HomeOption extends StatelessWidget {
  final String content;
  final Function() onPressed;
  const HomeOption({
    Key? key,
    required this.content,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
          color: const Color.fromARGB(255, 244, 244, 244),
          margin: const EdgeInsets.only(bottom: 25),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: SizedBox(
            width: 250,
            height: 150,
            child: Center(
              child: Text(content,
                  style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal)),
            ),
          )),
    );
  }
}
