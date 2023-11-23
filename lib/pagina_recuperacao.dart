import 'package:flutter/material.dart';
import 'package:dodi/banco_de_dados.dart';
////
class recuperacao extends StatefulWidget {
  @override
  State<recuperacao> createState() => _recuperacaoState();
}

class _recuperacaoState extends State<recuperacao> {
  TextEditingController _emailController = TextEditingController();
  final bancodeDados _auth = bancodeDados();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFC6F4F4),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5A7A7A),
          centerTitle: true,
          title: const Text('DODI'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 45,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(
                'assets/images/DODI_logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(height: 60),
              const Text(
                'E-mail para recuperação:',
                style: TextStyle(fontSize: 40, color: Color(0xFF5A7A7A)),
              ),
              const SizedBox(height: 60),
              TextField(
                controller: _emailController,
                style: const TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: const InputDecoration(
                  labelText: 'E-mail:',
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _validar();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF5A7A7A),
                    fixedSize: const Size(170, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Recuperar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  Future<void> _validar() async {
    String email = _emailController.text;
    if (email == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor preencha o campo "e-mail"'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      print(email);
        _auth.resetarSenha(email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail de recuperação enviado com sucesso'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }
}