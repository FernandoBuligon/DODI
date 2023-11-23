import 'package:dodi/pagina_visita.dart';
import 'package:dodi/banco_de_dados.dart';
import 'package:flutter/material.dart';


class projeto extends StatefulWidget {
  final String titulo;
  final String ideia;
  final String nome;
  final String data;
  final String email;

  projeto({
    required this.titulo,
    required this.email,
    required this.ideia,
    required this.nome,
    required this.data
  });

  @override
  State<projeto> createState() => _projetoState();
}

class _projetoState extends State<projeto> {
  late ImageProvider imagem = const AssetImage('assets/images/ico.png');

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
      backgroundColor: const Color(0xfffff5eb),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(width: 45),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => visita(nome: widget.nome, email: widget.email,),
                  ));
                },
                child: CircleAvatar(
                  radius: 45,
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
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                widget.nome,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                widget.data,
              ),
              const SizedBox(width: 15,)
            ],
          ),

          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Título: ${widget.titulo}',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Ideia: ${widget.ideia}',
            style: TextStyle(fontSize: 23),
          ),
        ],
      ),
    );
  }
}
