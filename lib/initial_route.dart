import "package:flutter/material.dart";
import 'package:libero/home/home.dart';
import 'package:libero/registro/registro.dart';
import 'package:libero/rotas.dart';

import 'cores.dart';
import 'estoque/estoque.dart';
import 'inspecionar_produto/inspecionar_produto.dart';
import 'models/produto.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class InitialRoute extends StatefulWidget {
  const InitialRoute({Key? key}) : super(key: key);

  @override
  State<InitialRoute> createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  int activeTab = 0;
  final PageController pageController = PageController();
  bool _showBottomNavigationBar = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () => setState(() => _showBottomNavigationBar = true));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _showBottomNavigationBar
            ? BottomNavigationBar(
                currentIndex: activeTab,
                backgroundColor: cinza,
                fixedColor: verdeEscuro,
                onTap: (value) {
                  if (activeTab != value) {
                    setState(() {
                      activeTab = value;
                    });
                    pageController.animateToPage(activeTab,
                        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
                  }
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: ""),
                  BottomNavigationBarItem(icon: Icon(Icons.list, size: 30), label: ""),
                ],
              )
            : null,
        body: PageView(
          controller: pageController,
          children: [
            KeepAlivePage(
              page: Navigator(
                key: navigatorKey,
                initialRoute: Rotas.home,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case Rotas.home:
                      return MaterialPageRoute(
                          builder: (context) => const KeepAlivePage(page: Home()), maintainState: true);
                    case Rotas.estoque:
                      return MaterialPageRoute(builder: (context) => const Estoque());
                    case Rotas.inspecionarProduto:
                      final produto = settings.arguments as Produto;
                      return MaterialPageRoute(builder: (context) => InspecionarProduto(produto: produto));
                  }
                  return null;
                },
              ),
            ),
            const KeepAlivePage(page: Registro())
          ],
        ),
      ),
    );
  }
}

/* PageView(controller: pageController, children: const [
        KeepAlivePage(page: Home()),
        KeepAlivePage(page: Registro()),
      ]) */

class KeepAlivePage extends StatefulWidget {
  final Widget page;
  const KeepAlivePage({Key? key, required this.page}) : super(key: key);

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.page;
  }

  @override
  bool get wantKeepAlive => true;
}
