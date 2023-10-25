import 'package:fincon_app/firebase/firebase_options.dart';
import 'package:fincon_app/screens/auth/login.dart';
import 'package:fincon_app/screens/home/home.dart';
import 'package:fincon_app/services/firebaseAuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuth = FirebaseAuthService().instanceFB;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fincon App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 1, 120, 5)),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => firebaseAuth.currentUser != null
            ? const HomePage()
            : const LoginPage(),
      },
      initialRoute: "/",
    );
  }
}
