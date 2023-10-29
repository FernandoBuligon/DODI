
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class bancodeDados {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> cadastro(String email, String password, String nome) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('usuario')
          .doc(credential.user?.uid)
          .set({'nome': nome, 'email': email});
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> login(String email, String senha) async {
    try {
      UserCredential data =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return data.user;
    } catch (e) {
      return null;
    }
  }

  Future<String> publicar(String titulo, List<String> tema, String resumo, String ideia, String? dono, String? nome) async {
    try {
      CollectionReference dados =
          FirebaseFirestore.instance.collection("ideia");

      dados.add({
        'titulo': titulo,
        'tema': tema,
        'resumo': resumo,
        'ideia': ideia,
        'dono': dono,
        'nomeUser': nome,
        'data': Timestamp.fromDate(DateTime.now()),
      });
      return "Ideia publicada com sucesso!";
    } catch (e) {
      return "Erro ao publicar a ideia";
    }
  }

  Future<String> excluir(String titulo) async {
    try {
      QuerySnapshot ideias = await FirebaseFirestore.instance
          .collection("ideia")
          .where('titulo', isEqualTo: titulo)
          .get();
      for (QueryDocumentSnapshot ideia in ideias.docs) {
        await FirebaseFirestore.instance
            .collection("ideia")
            .doc(ideia.id)
            .delete();
      }

      return "Ideia excluída com sucesso";
    } catch (e) {
      return "Erro ao excluir a ideia";
    }
  }

  Future<String> excluirM(String mensagem) async {
    try {
      QuerySnapshot ideias = await FirebaseFirestore.instance
          .collection("mensagem")
          .where('texto', isEqualTo: mensagem)
          .get();
      for (QueryDocumentSnapshot ideia in ideias.docs) {
        await FirebaseFirestore.instance
            .collection("mensagem")
            .doc(ideia.id)
            .delete();
      }

      return "Mensagem excluída com sucesso";
    } catch (e) {
      return "Erro ao excluir a mensagem";
    }
  }

  Future<String> enviarMensagem(String mensagem, String? dono, String? nome) async {
    try {
      CollectionReference dados =
          FirebaseFirestore.instance.collection("mensagem");
      dados.add({
        'texto': mensagem,
        'dono': dono,
        'nome': nome,
        'data': Timestamp.fromDate(DateTime.now()),
      });
      return "Mensagem enviada com suzxccesso!";
    } catch (e) {
      return "Erro ao publicar a mensagem";
    }
  }

  Future<String?> pegarNome() async {String? nome;
    try {
      String? user = _auth.currentUser?.email;
      var pesquisa = await FirebaseFirestore.instance
          .collection('usuario')
          .where('email', isEqualTo: user)
          .get();
      if (pesquisa.docs.isNotEmpty) {
        nome = pesquisa.docs[0]['nome'];
      }
    } catch (e) {
      print('Erro ao obter o nome: $e');
    }
    return nome;
  }

  Future<String?> pegarFoto(String email) async {
    String? url;
    try {

      var pesquisa = await FirebaseFirestore.instance
          .collection('usuario')
          .where('email', isEqualTo: email)
          .get();
      if (pesquisa.docs.isNotEmpty) {
        url = pesquisa.docs[0]['fotoPerfil'];
      }
    } catch (e) {
      print('Erro ao obter o url: $e');
    }
    print("urel retorno $url");
    return url;
  }

  Future resetarSenha(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<bool> conferirEmail(String email) async {
    try {
      print('email: $email');
      final List<String> usado =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      print(usado);
      if (usado.isEmpty) {
        print('object');
        return false;
      } else {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print("bag: $e");
      return false;
    }
  }

  Future<void> atualizarDados( String fotoPerfilUrl, String nome, String novoNome ) async {
    try {
      final User? user = _auth.currentUser;
      if(novoNome != ""){
        await FirebaseFirestore.instance
            .collection('usuario')
            .doc(user?.uid)
            .update({
          'nome': novoNome,
        });
        QuerySnapshot buscaNomeIdeia = await FirebaseFirestore.instance
            .collection('ideia')
            .where('nomeUser', isEqualTo: nome)
            .get();

        for (QueryDocumentSnapshot document in buscaNomeIdeia.docs) {
          await document.reference.update({
            'nomeUser': novoNome,
          });
        }
        QuerySnapshot buscaNomeMensagem = await FirebaseFirestore.instance
            .collection('mensagem')
            .where('nome', isEqualTo: nome)
            .get();

        for (QueryDocumentSnapshot document in buscaNomeMensagem.docs) {
          await document.reference.update({
            'nome': novoNome,
          });
        }

      }
      if(fotoPerfilUrl != ""){
        await FirebaseFirestore.instance
            .collection('usuario')
            .doc(user?.uid)
            .update({
          'fotoPerfil': fotoPerfilUrl,
        });
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
