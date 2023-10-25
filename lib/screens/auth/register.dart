import 'package:fincon_app/screens/auth/login.dart';
import 'package:fincon_app/screens/home/home.dart';
import 'package:fincon_app/services/firebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  var authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()));
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
        ),
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
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                    ),
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
                      controller: _incomeController,
                      decoration: const InputDecoration(labelText: 'Renda'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu renda';
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
                            await authService.createAccountWithEmailAndPwd(
                                _nameController.text,
                                _incomeController.text,
                                _emailController.text,
                                _passwordController.text);

                            if (authService.instanceFB.currentUser != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_showMsg("Senha fraca :("));
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _showMsg("E-mail já está sendo usado."));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(_showMsg(
                                "Houve um problema ao realizar o cadastro."));
                          }
                        }
                      },
                      child: const Text('Cadastrar'),
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
        style: const TextStyle(
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
