import 'package:acacia/main.dart';
import 'package:acacia/p_listagem_anotacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*
class ObjPagina {
  List<String> emocao = ["😊", "😢", "😡", "😴"];
  String emocaoSelecionada = "";
  List<String> _listTextos = [];
  File? imagem;
  List<File> imagens = [];
  Map<int, dynamic> anotacaoFinal = {};

  void aicionarParteFinal(dynamic parte) {
    int i = anotacaoFinal.length;
    if (i > 0) i++;
    if (parte is String) {
      anotacaoFinal[i] = parte;
    }
    if (parte is File) {
      anotacaoFinal[i] = parte;
    }
  }

  void adicionarTexto(String texto) {
    _listTextos.add(texto);
  }

  

  Future<File?> pegarImagemGaleria() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return null;

    final file = File(img.path);
    this.imagem = file;
    return file;
  }

  Future<File?> pegarImagemCamera() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img == null) return null;

    final file = File(img.path);
    this.imagem = file;
    return file;
  }
}*/

//Página que salva as anotações do diário no banco de dados
class Anotacao extends StatefulWidget {
  final DateTime dia;
  const Anotacao({super.key, required this.dia});

  @override
  State<Anotacao> createState() => _AnotacaoState();
}

class _AnotacaoState extends State<Anotacao> {
  //ObjPagina objPagina = ObjPagina();

  final _fromKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> emocoes = ["😊", "😢", "😡", "😴"];
  String emocaoSelecionada = "";
  final TextEditingController _textoController = TextEditingController();
  List<File> imagens = [];
  String dia = '';
  String hoje =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Anotação do dia"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hoje,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 250),
                    ElevatedButton(
                      onPressed: () => _registrarAnotacao(),
                      child: Text("Salvar"),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {setState(() {
                        emocaoSelecionada = "feliz";
                      });},
                      icon: Text("😊", style: TextStyle(fontSize: 30)),
                    ),
                    IconButton(
                      onPressed: () {setState(() {
                        emocaoSelecionada = "triste";
                      });},
                      icon: Text("😢", style: TextStyle(fontSize: 30)),
                    ),
                    IconButton(
                      onPressed: () {setState(() {
                        emocaoSelecionada = "raiva";
                      });},
                      icon: Text("😡", style: TextStyle(fontSize: 30)),
                    ),
                    IconButton(
                      onPressed: () {setState(() {
                        emocaoSelecionada = "tedio";
                      });},
                      icon: Text("😴", style: TextStyle(fontSize: 30)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _textoController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "Escreva seus pensamentos aqui...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => Placeholder(),
                  icon: Icon(Icons.image),
                  label: Text("Adicionar imagem"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _executaConsulta(
    BuildContext context,
    Query<Map<String, dynamic>> query,
  ) async {
    var snapshot = await query.get();
    List<Map<String, dynamic>> anotacoes = snapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();
    _listarAnotacoes(context, anotacoes);
  }

  void _listarAnotacoes(
    BuildContext context,
    List<Map<String, dynamic>> anotacoes,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListagemAnotacoes(anotacoes: anotacoes),
      ),
    );
  }
  /*String emocao = '';
  final TextEditingController _textoController = TextEditingController();
  List<File> imagens = [];
  String dia = ''; */

  void _registrarAnotacao() async {
    List<String> urls = [];

    for (int i = 0; i < imagens.length; i++) {
      final File img = imagens[i];
      final storageRef = FirebaseStorage.instance.ref().child(
        'anotacoes/${hoje}_img_$i.jpg',
      );

      final uploadTask = storageRef.putFile(img);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }
    if (_fromKey.currentState!.validate()) {
      try {
        await firestore.collection('anotacoes').add({
          'texto': _textoController.text,
          'imagens': urls,
          'dia': hoje,
          'emocao': emocaoSelecionada.isNotEmpty ? emocaoSelecionada : null,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Anotação registrada com sucesso")),
        );
        _fromKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
    }
  }
}
