import 'package:flutter/material.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: const TabBarView(
            children: [
              HomeContentTab(),
              Icon(Icons.directions_transit),
            ],
          ),
        ));
  }
}

class HomeContentTab extends StatefulWidget {
  const HomeContentTab({super.key});

  @override
  State<StatefulWidget> createState() => _HomeContentTabState();
}

class _HomeContentTabState extends State<HomeContentTab> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem vindo ao FinCon!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Guia "Categorias" => Permite cadastar as categorias dos seus gastos.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Guia "Meus Gastos" => Permite cadastar seus gastos, diarios e fixos.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
