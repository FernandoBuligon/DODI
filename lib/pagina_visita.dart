import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodi/pagina_projeto.dart';
import 'package:dodi/banco_de_dados.dart';

class visita extends StatefulWidget {

  final String nome;
  final String email;

  visita({
    required this.nome,
    required this.email,
  });

  @override
  State<visita> createState() => _visitaState();
}
class _visitaState extends State<visita> {
  late ImageProvider imagem;

  final bancodeDados _bd = bancodeDados();

  void initState() {
    super.initState();
    _imagemPerfil(widget.email);
  }

  Future<void> _imagemPerfil(String email) async {
    print('cheguei aqui caralho');
    String? url = await _bd.pegarFoto(email);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: const Color(0xFFC6F4F4),
      body: Column(
        children: [
          const SizedBox(height: 45),
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
          const SizedBox(height: 45),
          const Text(
            "E-mail para contato:",
            style: TextStyle(fontSize: 26, color: const Color(0xFF5A7A7A)),
          ),
          const SizedBox(height: 15),
          Text(
            widget.email,
            style: TextStyle(fontSize: 20, color: const Color(0xFF5A7A7A)),
          ),
          const SizedBox(height: 15),
          Text(
            "Ideias de ${widget.nome}:",
            style: TextStyle(fontSize: 26, color: const Color(0xFF5A7A7A)),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ideia')
                  .where('nomeUser', isEqualTo: widget.nome)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
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
}
