import 'package:dodi/pagina_cadastro.dart';
import 'package:dodi/pagina_inicial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dodi/firebase_options.dart';
import 'banco_de_dados.dart';
import 'package:dodi/pagina_recuperacao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool pode = false;

  @override
  void initState() {
    logado();
    super.initState();
  }

  void logado() async {
    User? user = _auth.currentUser;
    pode = user != null;
    setState(() {
      if (pode) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Inicial()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: pode ? Inicial() : Entrada(),
    );
  }
}

class Entrada extends StatefulWidget {
  Entrada({super.key});

  @override
  State<Entrada> createState() => _EntradaState();
}

class _EntradaState extends State<Entrada> {
  final bancodeDados _auth = bancodeDados();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  bool mostrarSenha = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6F4F4),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/images/DODI_logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(height: 35),
              const Text(
                'Login',
                style: TextStyle(fontSize: 40, color: Color(0xFF5A7A7A)),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _emailController,
                style: TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'E-mail:',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _senhaController,
                obscureText: !mostrarSenha,
                style: const TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'Senha:',
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarSenha = !mostrarSenha;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _login();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF5A7A7A),
                    fixedSize: const Size(170, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                'assets/images/rabisco.png',
                width: MediaQuery.of(context).size.width * 1,
                alignment: Alignment.bottomCenter,
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cadastro()),
                  );
                },
                child: const Text(
                  "Criar conta",
                  style: TextStyle(
                    color: Color(0xFF5A7A7A),
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => recuperacao()),
                  );
                },
                child: const Text(
                  "Recuperar senha",
                  style: TextStyle(
                    color: Color(0xFF5A7A7A),
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _login() async {
    String email = _emailController.text;
    String senha = _senhaController.text;
    User? user = await _auth.login(email, senha);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Inicial()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou senha inválidos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
