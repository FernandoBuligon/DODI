import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodi/banco_de_dados.dart';
import 'package:dodi/pagina_login.dart';
import 'package:dodi/pagina_projeto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dodi/pagina_config.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  bool adm = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    String? email = _auth.currentUser?.email;
    if (email == "fbuligonantunes@gmail.com") {
      adm = true;
    }
  }

  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  Widget _buildPage(Widget child) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFC6F4F4),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6F4F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: const Color(0xFF5A7A7A),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("DODI"),
        ),
      ),
      body: adm
          ? PageView(
              controller: _pageController,
              children: [
                _buildPage(feed()),
                _buildPage(ideia()),
                _buildPage(chat()),
                _buildPage(perfil()),
                _buildPage(usuarios()),
              ],
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : PageView(
              controller: _pageController,
              children: [
                _buildPage(feed()),
                _buildPage(ideia()),
                _buildPage(chat()),
                _buildPage(perfil()),
              ],
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
      bottomNavigationBar: adm
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_outline),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.3),
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_outlined),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_outline),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  backgroundColor: Color(0xFF5A7A7A),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.3),
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
    );
  }
}

class feed extends StatefulWidget {
  @override
  State<feed> createState() => _feedState();
}

class _feedState extends State<feed> {
  final bancodeDados _bd = bancodeDados();
  bool adm = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    String? email = _auth.currentUser?.email;
    if (email == "fbuligonantunes@gmail.com") {
      adm = true;
    }
  }

  TextEditingController _pesquisaController = TextEditingController();
  String pesquisa = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(08.0),
            child: TextField(
              controller: _pesquisaController,
              style: const TextStyle(
                color: Color(0xFF5A7A7A),
              ),
              decoration: InputDecoration(
                labelText: 'Pesquisar:',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      pesquisa = _pesquisaController.text;
                    });
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ideia')
                  .where('tema', arrayContains: pesquisa)
                  .orderBy('data', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var ideias = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: ideias.length,
                  itemBuilder: (context, index) {
                    var dado = ideias[index].data();
                    var titulo = dado['titulo'];
                    List<dynamic> temal = dado['tema'];
                    String tema = temal.join(' ');
                    var resumo = dado['resumo'];
                    var ideia = dado['ideia'];
                    var email = dado['dono'];
                    var nome = dado['nomeUser'];
                    var data =
                        DateFormat('dd/MM/yyyy').format(dado['data'].toDate());

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => projeto(
                              titulo: titulo,
                              email: email,
                              ideia: ideia,
                              nome: nome,
                              data: data),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfffff5eb),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              adm
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          alignment:
                                              FractionalOffset.centerRight,
                                          onPressed: () {
                                            excluir(titulo);
                                          },
                                          icon: const Icon(
                                            Icons.restore_from_trash,
                                            color: Color(0xffaa080e),
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(),
                              Text(
                                titulo,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Tema: $tema",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Resumo: $resumo",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void excluir(String titulo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirma a exclusão da ideia?'),
          content: const Text('Após apagar, não é possível recuperar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String e = await _bd.excluir(titulo);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

class ideia extends StatefulWidget {
  @override
  State<ideia> createState() => _ideiaState();
}

class _ideiaState extends State<ideia> {
  final bancodeDados _bd = bancodeDados();

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _temaController = TextEditingController();
  TextEditingController _resumoController = TextEditingController();
  TextEditingController _ideiaController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _temaController.dispose();
    _resumoController.dispose();
    _ideiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        color: const Color(0xFFC6F4F4),
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const Text(
                'Ideia',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF5A7A7A)),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _tituloController,
                style: TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'Título:',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _temaController,
                style: TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'Tema:',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _resumoController,
                style: TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'Resumo:',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _ideiaController,
                style: TextStyle(
                  color: Color(0xFF5A7A7A),
                ),
                decoration: InputDecoration(
                  labelText: 'Ideia:',
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              TextButton(
                onPressed: () {
                  _publicar();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5A7A7A),
                  fixedSize: const Size(170, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Publicar",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _publicar() async {
    String titulo = _tituloController.text;
    String tema = _temaController.text + " ";
    List<String> temas = tema.split(' ');
    String resumo = _resumoController.text;
    String ideia = _ideiaController.text;

    if (titulo != "" && tema != "" && resumo != "" && ideia != "") {
      User? user = FirebaseAuth.instance.currentUser;
      String? nome = await _bd.pegarNome();
      _tituloController.clear();
      _temaController.clear();
      _resumoController.clear();
      _ideiaController.clear();
      String dados =
          await _bd.publicar(titulo, temas, resumo, ideia, user?.email, nome);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dados),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor preencha todos os campos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class chat extends StatefulWidget {
  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  bool adm = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    String? email = _auth.currentUser?.email;
    if (email == "fbuligonantunes@gmail.com") {
      adm = true;
    }
  }

  final bancodeDados _bd = bancodeDados();
  TextEditingController _mensagemController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Como posso estimular a criatividade?",
            style: TextStyle(fontSize: 20, color: Color(0xFF5A7A7A)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('mensagem')
                  .orderBy('data', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var mensagens = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    var dado = mensagens[index].data();
                    var mensagem = dado['texto'];
                    String dono = dado['dono'];
                    var nome = dado['nome'];
                    bool eodono = dono == user?.email;
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: eodono
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: eodono
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              adm
                                  ? IconButton(
                                      alignment: FractionalOffset.centerRight,
                                      onPressed: () {
                                        excluir(mensagem);
                                      },
                                      icon: const Icon(
                                        Icons.restore_from_trash,
                                        color: Color(0xffaa080e),
                                        size: 30,
                                      ),
                                    )
                                  : Row(),
                              Text(
                                nome,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF5EB),
                                  borderRadius: BorderRadius.only(
                                    topLeft: eodono
                                        ? const Radius.circular(20.0)
                                        : const Radius.circular(0.0),
                                    topRight: eodono
                                        ? const Radius.circular(0.0)
                                        : const Radius.circular(20.0),
                                    bottomRight: const Radius.circular(20.0),
                                    bottomLeft: const Radius.circular(20.0),
                                  ),
                                ),
                                child: Align(
                                  alignment: eodono
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      mensagem,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(08.0),
            child: TextField(
              controller: _mensagemController,
              style: const TextStyle(
                color: Color(0xFF5A7A7A),
              ),
              decoration: InputDecoration(
                labelText: 'Digite sua mensagem:',
                suffixIcon: IconButton(
                  onPressed: () {
                    _enviarMensagem();
                  },
                  icon: Icon(Icons.send),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void excluir(String mensagem) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirma a exclusão da mensagem?'),
          content: const Text('Após apagar, não é possível recuperar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String e = await _bd.excluirM(mensagem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _enviarMensagem() async {
    String mensagem = _mensagemController.text;
    if (mensagem != "") {
      User? user = FirebaseAuth.instance.currentUser;
      _mensagemController.clear();
      String? nome = await _bd.pegarNome();
      String dados = await _bd.enviarMensagem(mensagem, user?.email, nome!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dados),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor digite uma mensagem'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class perfil extends StatefulWidget {
  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  late ImageProvider imagem;
  final bancodeDados _bd = bancodeDados();
  void initState() {
    super.initState();
    _imagemPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 45),
          Row(
            children: [
              const SizedBox(width: 45),
              CircleAvatar(
                radius: 85,
                backgroundImage: imagem,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF5A7A7A),
                      width: 4.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfigPerfil()),
                      );
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Color(0xFF5A7A7A),
                      size: 48,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  IconButton(
                    onPressed: () {
                      _sair();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xFF5A7A7A),
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 45),
          const Text(
            "Suas ideias:",
            style: TextStyle(fontSize: 26, color: Color(0xFF5A7A7A)),
          ),
          const SizedBox(height: 25),
          SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ideia')
                  .where('dono', isEqualTo: user?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var ideias = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ideias.length,
                  itemBuilder: (context, index) {
                    var dado = ideias[index].data();
                    var titulo = dado['titulo'];
                    List<dynamic> temal = dado['tema'];
                    String tema = temal.join(' ');
                    var resumo = dado['resumo'];
                    var email = dado['dono'];
                    var ideia = dado['ideia'];
                    var nome = dado['nomeUser'];
                    var data =
                        DateFormat('dd/MM/yyyy').format(dado['data'].toDate());
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => projeto(
                              titulo: titulo,
                              email: email,
                              ideia: ideia,
                              nome: nome,
                              data: data),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfffff5eb),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    alignment: FractionalOffset.centerRight,
                                    onPressed: () {
                                      excluir(titulo);
                                    },
                                    icon: const Icon(
                                      Icons.restore_from_trash,
                                      color: Color(0xffaa080e),
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                titulo,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Tema: $tema",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Resumo: $resumo",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _imagemPerfil() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String? email = _auth.currentUser?.email;
    String? url = await _bd.pegarFoto(email!);
    print("URL da imagem: $url");

    if (url != null && url.isNotEmpty) {
      setState(() {
        imagem = NetworkImage(url);
      });
    } else {
      setState(() {
        imagem = const AssetImage('assets/images/ico.png');
      });
    }
  }

  void _sair() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Entrada()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('erro: $e');
    }
  }

  void excluir(String titulo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirma a exclusão da ideia?'),
          content: const Text('Após apagar, não é possível recuperar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String e = await _bd.excluir(titulo);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

class usuarios extends StatefulWidget {
  @override
  State<usuarios> createState() => _usuariosState();
}

class _usuariosState extends State<usuarios> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  late ImageProvider imagem;
  final bancodeDados _bd = bancodeDados();
  void initState() {
    super.initState();
    _imagemPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('usuario').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var usuarios = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    var dado = usuarios[index].data();
                    var nome = dado['nome'];
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfffff5eb),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: imagem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF5A7A7A),
                                      width: 4.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    alignment: FractionalOffset.centerRight,
                                    onPressed: () {
                                      excluir(nome);
                                    },
                                    icon: const Icon(
                                      Icons.restore_from_trash,
                                      color: Color(0xffaa080e),
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                nome,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Tema: $nome",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Resumo: $nome",
                                      style: const TextStyle(fontSize: 18),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                );
              },
            ),
          )

    );
  }

  Future<void> _imagemPerfil() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String? email = _auth.currentUser?.email;
    String? url = await _bd.pegarFoto(email!);
    print("URL da imagem: $url");

    if (url != null && url.isNotEmpty) {
      setState(() {
        imagem = NetworkImage(url);
      });
    } else {
      setState(() {
        imagem = const AssetImage('assets/images/ico.png');
      });
    }
  }
  void excluir(String titulo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirma a exclusão da ideia?'),
          content: const Text('Após apagar, não é possível recuperar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String e = await _bd.excluir(titulo);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicial(),
  ));
}
