import 'package:dodi/banco_de_dados.dart';
import 'package:dodi/pagina_inicial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
/////
class ConfigPerfil extends StatefulWidget {
  ConfigPerfil({Key? key});

  @override
  State<ConfigPerfil> createState() => _ConfigPerfilState();
}

class _ConfigPerfilState extends State<ConfigPerfil> {

  File? imagem;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bancodeDados _bd = bancodeDados();
  TextEditingController _nomeController = TextEditingController();
  late ImageProvider image = const AssetImage('assets/images/ico.png');
  void initState() {
    super.initState();
    _imagemPerfil();
  }

  Future<void> _imagemPerfil() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String? email = _auth.currentUser?.email;
    String? url = await _bd.pegarFoto(email!);
    print("URL da imagem: $url");

    if (url != null && url.isNotEmpty) {
      setState(() {
        image = NetworkImage(url);
      });
    } else {
      setState(() {
        image = const AssetImage('assets/images/ico.png');
      });
    }
  }
  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _escolherImagem() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 300,
        maxHeight: 300,
      );

      if (croppedFile != null) {
        setState(() {
          imagem = File(croppedFile.path);
        });
      }
    }
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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(width: 45),
                CircleAvatar(
                  radius: 85,
                  backgroundImage: image,
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
                IconButton(
                  onPressed: () {
                    _escolherImagem();
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Color(0xFF5A7A7A),
                    size: 48,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _nomeController,
              style: const TextStyle(
                color: Color(0xFF5A7A7A),
              ),
              decoration: const InputDecoration(
                labelText: 'Novo nome:',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                _salvar();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF5A7A7A),
                fixedSize: const Size(170, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Atualizar dados",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _salvar() async {
    final user = _auth.currentUser;
    final id = user?.uid;
    if (imagem != null) {
      final storageRef = FirebaseStorage.instance.ref().child(id!);
      final uploadTask = storageRef.putFile(imagem!);
      try {
        await uploadTask.whenComplete(() async {
          final url = await storageRef.getDownloadURL();
          await _bd.atualizarDados(url, "", "");
        });
      } catch (e) {
        print('Erro: $e');
      }
    }
    if (_nomeController != null) {
      String? nome = await _bd.pegarNome();
      await _bd.atualizarDados("", nome!, _nomeController.text);
      _nomeController.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados salvos com sucesso'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Inicial()),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ConfigPerfil(),
        ),
      ),
    ),
  );
}
