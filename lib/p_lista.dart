import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'funcoes_multiplataforma.dart';

class ObjLista {
  bool check;
  int posicao;
  String texto;
  XFile? imagem;
  List<XFile> imagens = [];

  ObjLista({this.check = false, this.texto = "", this.posicao = 0});
}

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
            icon: const Icon(Icons.add),
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
                if (sublista.isEmpty) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
                                    icon: const Icon(Icons.add_a_photo_outlined),
                                    onPressed: () async {
                                      final img = await escolherImagem(context);
                                      if (img != null) {
                                        setState(() {
                                          item.imagens.add(img);
                                        });
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        removerColuna(linha, coluna);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),

                              if (item.imagens.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.imagens.length,
                                    itemBuilder: (_, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: mostrarImagem(
                                            item.imagens[i],
                                            altura: 100,
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
                              icon: const Icon(Icons.add),
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
