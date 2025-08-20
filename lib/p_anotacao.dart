import 'package:acacia/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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

  String dia = '';
  String emocao = '';
  final TextEditingController _textoController = TextEditingController();
  File? _imagem;

  

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
                  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 250,),
                ElevatedButton(
                    onPressed: () {},
                    child: Text("Salvar"),
                  ),
                
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < objPagina.emocao.length; i++)
                      Text(objPagina.emocao[i], style: TextStyle(fontSize: 38)),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
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
                  onPressed: () {},
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
}
