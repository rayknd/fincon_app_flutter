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
          appBar: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: const SafeArea(
              child: TabBar(
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.home,
                    color: Colors.green,
                  )),
                  Tab(icon: Icon(Icons.payments, color: Colors.green)),
                ],
              ),
            ),
          ),
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
