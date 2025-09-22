import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';          
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../funcoes_multiplataforma.dart';

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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get _userListasCol =>
      firestore.collection('users').doc(_uid).collection('listas');

  Future<void> salvarLista(int linha) async {
    if (linha >= matrizDeListas.length) {
      aumentarLinha();
    }

    if (matrizDeListas[linha].isEmpty) {
      aumentarColunas(linha);
    }

    for (int i = 0; i < matrizDeListas[linha].length; i++) {
      final List<String> urls = [];

      for (int j = 0; j < matrizDeListas[linha][i].imagens.length; j++) {
        final XFile img = matrizDeListas[linha][i].imagens[j];
        final caminho = 'users/$_uid/listas/linha_${linha}_item_${i}_img_${j}.jpg';
        try {
          final url = await uploadImagem(caminho, img);
          urls.add(url);
        } catch (e, st) {
          debugPrintStack(stackTrace: st);
        }
      }

      try {
        final docRef = await _userListasCol.add({
          'texto': matrizDeListas[linha][i].texto,
          'imagens': urls,
          'check': matrizDeListas[linha][i].check,
        });
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $e")),
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lista salva com sucesso!")),
    );
  }

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
              setState(aumentarLinha);
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment(0.95, 0),
                          child: ElevatedButton(
                            onPressed: () => salvarLista(linha),
                            child: const Text("Salvar lista"),
                          ),
                        ),
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
                                    onChanged: (v) =>
                                        setState(() => item.check = v!),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: item.texto,
                                      onChanged: (v) =>
                                          setState(() => item.texto = v),
                                      decoration: InputDecoration(
                                        hintText: "Item $coluna",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.add_a_photo_outlined),
                                    onPressed: () async {
                                      final img =
                                          await escolherImagem(context);
                                      if (img != null) {
                                        setState(() =>
                                            item.imagens.add(img));
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        setState(() => removerColuna(linha, coluna)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (item.imagens.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.imagens.length,
                                    itemBuilder: (_, i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: "Adicionar item",
                              onPressed: () {
                                setState(() => aumentarColunas(linha));
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
