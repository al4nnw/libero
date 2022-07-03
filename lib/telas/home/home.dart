import 'package:flutter/material.dart';

import '../../rotas.dart';
import 'home_option.dart';

final homeStateController = ValueNotifier<int>(0);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _topPosition = false;
  late double _initialHeight;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 2),
        () => setState(() {
              _topPosition = true;
            }));
  }

  @override
  void didChangeDependencies() {
    _initialHeight = MediaQuery.of(context).size.height * 0.45;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPositioned(
            top: _topPosition ? MediaQuery.of(context).padding.top + 50 : _initialHeight,
            width: 200,
            duration: const Duration(milliseconds: 600),
            child: Image.asset("assets/libero_preto.png", fit: BoxFit.contain)),
        Positioned(
          bottom: 0,
          left: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _topPosition ? 1 : 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 200),
                  HomeOption(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Rotas.estoque);
                    },
                    content: "Estoque",
                  ),
                  HomeOption(
                    onPressed: () {},
                    content: "Financeiro",
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
/* 
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    homeStateController.addListener(_setState);
  }

  @override
  void dispose() {
    homeStateController.removeListener(_setState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (homeStateController.value) {
      case 0:
        return Home();
      case
    }
    return const Scaffold();
  }

  _setState() => setState(() {});
}
 */