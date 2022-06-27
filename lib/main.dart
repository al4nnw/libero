import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libero/cores.dart';
import 'package:libero/initial_route.dart';

import 'firebase_options.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Libero());
}

class Libero extends StatelessWidget {
  const Libero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: const InitialRoute(),
        navigatorKey: rootNavigatorKey,
        theme: ThemeData(
          fontFamily: "WorkSans",
          primaryColor: verdeClaro,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
