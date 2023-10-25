import 'package:fincon_app/screens/auth/login.dart';
import 'package:fincon_app/screens/category/category_index.dart';
import 'package:fincon_app/screens/expense/expense_index.dart';
import 'package:fincon_app/screens/home/home_content.dart';
import 'package:fincon_app/services/firebaseAuthService.dart';
import 'package:fincon_app/services/firestoreService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContentPage(),
    const ExpenseIndexPage(),
    const CategoryIndexPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuthService();

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fincon'),
                IconButton(
                  onPressed: () async {
                    await firebaseAuth.logout();

                    if (firebaseAuth.instanceFB.currentUser == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginPage()));
                    }
                  },
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payments),
                label: 'Gastos fixos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.style),
                label: 'Categorias',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            onTap: _onItemTapped,
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
    );
  }
}
