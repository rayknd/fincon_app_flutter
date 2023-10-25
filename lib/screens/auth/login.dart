import 'package:fincon_app/screens/auth/register.dart';
import 'package:fincon_app/screens/home/home.dart';
import 'package:fincon_app/services/firebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await authService.loginWithEmailAndPassword(
                            _emailController.text, _passwordController.text);

                        if (authService.instanceFB.currentUser != null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              _showMsg("As credenciais estão inválidas"));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            _showMsg("Houve um problema ao realizar login"));
                      }
                    }
                  },
                  child: const Text('Entrar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
                  },
                  child: const Text('Criar novo usuário'),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.white,
    );
    return snackBar;
  }
}
