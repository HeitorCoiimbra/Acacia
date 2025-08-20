import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ObjLista {
  bool check;
  int posicao;
  String texto;
  File? imagem;
  List<File> imagens = [];

  ObjLista({this.check = false, this.texto = "", this.posicao = 0});

  // Agora retorna o File selecionado
  Future<File?> pegarImagemGaleria() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (img == null) return null;

    final file = File(img.path);
    this.imagem = file;
    return file;
  }

  Future<File?> pegarImagemCamera() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (img == null) return null;

    final file = File(img.path);
    this.imagem = file;
    return file;
  }
}

//Página que tem como objetivo ser uma lista dinâmica que ajude o usuário a lembrar
//de coisas que fez ou que ainda tenha que fazer, como tomar um remédio ou se fechou
//a janela antes de sair de casa
class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<List<ObjLista>> matrizDeListas = [];

  void aumentarLinha() {
    matrizDeListas.add([ObjLista()]);
  }

  void aumentarColunas(int linha) {
    final qtd = matrizDeListas[linha].length;
    matrizDeListas[linha].add(ObjLista(posicao: qtd));
  }

  void removerColuna(int linha, int pos) {
    matrizDeListas[linha].removeAt(pos);
    if (matrizDeListas[linha].isEmpty) {
      matrizDeListas.removeAt(linha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Listas", style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "Adicionar lista",
            onPressed: () {
              setState(() {
                aumentarLinha();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: matrizDeListas.length,
              itemBuilder: (context, linha) {
                final sublista = matrizDeListas[linha];
                if (sublista.isEmpty) return SizedBox.shrink();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // cada objeto da sublista
                        ...sublista.asMap().entries.map((entry) {
                          final coluna = entry.key;
                          final item = entry.value;
                          item.posicao = coluna;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: item.check,
                                    onChanged: (v) => setState(() {
                                      item.check = v!;
                                    }),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: item.texto,
                                      onChanged: (v) => setState(() {
                                        item.texto = v;
                                      }),
                                      decoration: InputDecoration(
                                        hintText: "Item $coluna",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_a_photo_outlined),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (ctx) => Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Adicionar imagem"),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final f = await item
                                                      .pegarImagemGaleria();
                                                  if (f != null) {
                                                    setState(() {
                                                      item.imagens.add(f);
                                                    });
                                                  }
                                                  Navigator.pop(ctx);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.image_outlined,
                                                      size: 28,
                                                    ),
                                                    SizedBox(width: 16),
                                                    Text("Da galeria"),
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(onPressed: () async {
                                                final f = await item
                                                .pegarImagemCamera();
                                                if (f != null){
                                                  setState(() {
                                                    item.imagens.add(f);
                                                  });
                                                }
                                                Navigator.pop(ctx);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 28,
                                                  ),
                                                  SizedBox(width: 16,),
                                                  Text("Da câmera"),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        removerColuna(linha, coluna);
                                      });
                                    },
                                  ),
                                ],
                              ),

                              // mostra as imagens (horizontal)
                              if (item.imagens.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.imagens.length,
                                    itemBuilder: (_, i) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            item.imagens[i],
                                            height: 100,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        }).toList(),

                        // botão de adicionar coluna à linha atual
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              tooltip: "Adicionar item",
                              onPressed: () {
                                setState(() {
                                  aumentarColunas(linha);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}