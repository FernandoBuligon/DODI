import 'package:email_validator/email_validator.dart';
import 'package:dodi/banco_de_dados.dart';
import 'package:dodi/pagina_inicial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final bancodeDados _auth = bancodeDados();

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _senha2Controller = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _senha2Controller.dispose();
    super.dispose();
  }
  bool mostrarSenha = false;
  bool mostrarSenha2 = false;

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
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/DODI_logo.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    const SizedBox(height: 35),
                    const Text(
                      'Cadastro',
                      style: TextStyle(fontSize: 40, color: Color(0xFF5A7A7A)),
                    ),
                    const SizedBox(height: 35),
                    TextField(
                      controller: _nomeController,
                      style: const TextStyle(
                        color: Color(0xFF5A7A7A),
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Nome de usuário:',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: Color(0xFF5A7A7A),
                      ),
                      decoration: const InputDecoration(
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _senha2Controller,
                      obscureText: !mostrarSenha2,
                      style: const TextStyle(
                        color: Color(0xFF5A7A7A),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha:',
                        suffixIcon: IconButton(
                          icon: Icon(
                            mostrarSenha2 ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              mostrarSenha2 = !mostrarSenha2;
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
                          _cadastro();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF5A7A7A),
                          fixedSize: const Size(170, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Criar conta",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  void _cadastro() async {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String senha2 = _senha2Controller.text;
    int verificador = validarDados(nome, email, senha, senha2);

    if (verificador == 1) {
      User? user = await _auth.cadastro(email, senha, nome);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Inicial()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O email inserido já está em uso'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  int validarDados(String n, String e, String s, String s2) {
    int validos = 0;
    //validação de campos preenchidos
    if (n != "" && e != "" && s != "" && s2 != "") {
      //validação de email
      if (EmailValidator.validate(e)) {
        //verifica se a senha tem 6 caracteres
        if (s.length >= 6) {
          // Verifica se a senha do campo de confirmação é igual a senha do primeiro campo
          if (s == s2) {
            validos = 1;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('As duas senhas não coincidem'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('A senha precisa ter ao menos 6 caracteres'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor insira um email válido'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor preencha todos os campos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (validos == 1) {
      return 1;
    } else {
      return 0;
    }
  }
}
