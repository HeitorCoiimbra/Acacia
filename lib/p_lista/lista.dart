import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../funcoes_multiplataforma.dart';

class ObjLista {
  bool check;
  int posicao;
  String texto;
  List<XFile> imagens = []; // imagens novas
  List<String> urlsSalvas = []; // imagens já enviadas
  final TextEditingController controller;

  ObjLista({
    this.check = false,
    this.texto = "",
    this.posicao = 0,
  }) : controller = TextEditingController(text: texto);

  void adicionarImagem(XFile img) {
    imagens.add(img);
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': controller.text,
      'check': check,
      'imagens': urlsSalvas,
    };
  }
}

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<List<ObjLista>> matrizDeListas = [];
  List<String?> docIds = []; // ids dos documentos
  List<TextEditingController> tituloControllers = []; // controllers dos títulos
  String pasta = "listas";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get _userListasCol =>
      firestore.collection('users').doc(_uid).collection('listas');

  @override
  void initState() {
    super.initState();
    carregarListas();
  }

  Future<void> carregarListas() async {
    final snapshot = await _userListasCol.get();
    final listas = snapshot.docs;

    setState(() {
      matrizDeListas = [];
      docIds = [];
      tituloControllers = [];
      for (final doc in listas) {
        final data = doc.data();
        final titulo = data['titulo'] ?? '';
        final itens = List<Map<String, dynamic>>.from(data['itens'] ?? []);
        final objs = itens.asMap().entries.map((entry) {
          final i = entry.value;
          final obj = ObjLista(
            texto: i['texto'] ?? '',
            check: i['check'] ?? false,
            posicao: entry.key,
          );
          obj.urlsSalvas = List<String>.from(i['imagens'] ?? []);
          return obj;
        }).toList();

        if (objs.isEmpty) objs.add(ObjLista());
        matrizDeListas.add(objs);
        docIds.add(doc.id);
        tituloControllers.add(TextEditingController(text: titulo));
      }
    });
  }

  Future<void> salvarLista(int linha) async {
    final lista = matrizDeListas[linha];
    final titulo = tituloControllers[linha].text;
    final List<Map<String, dynamic>> itensFinal = [];

    for (final item in lista) {
      final List<String> urlsFinais = List.from(item.urlsSalvas);

      for (final img in item.imagens) {
        try {
          final url = await uploadImagem(img, pasta: pasta);
          if (url != null && url.isNotEmpty) {
            urlsFinais.add(url);
          }
        } catch (e, st) {
          debugPrintStack(stackTrace: st);
        }
      }

      item.urlsSalvas = urlsFinais;
      item.imagens.clear();
      itensFinal.add(item.toMap());
    }

    try {
      final docId = docIds.length > linha ? docIds[linha] : null;
      if (docId == null) {
        final docRef = await _userListasCol.add({
          'titulo': titulo,
          'itens': itensFinal,
        });
        if (docIds.length <= linha) {
          docIds.add(docRef.id);
        } else {
          docIds[linha] = docRef.id;
        }
      } else {
        await _userListasCol.doc(docId).update({
          'titulo': titulo,
          'itens': itensFinal,
        });
      }
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Lista salva com sucesso!")));
  }

  void aumentarLinha() {
    setState(() {
      matrizDeListas.add([ObjLista()]);
      docIds.add(null);
      tituloControllers.add(TextEditingController());
    });
  }

  void aumentarColunas(int linha) {
    final qtd = matrizDeListas[linha].length;
    setState(() {
      matrizDeListas[linha].add(ObjLista(posicao: qtd));
    });
  }

  // Remoção local (edição), sem persistir ainda; só será persistida ao salvar
  void removerItemLocal(int linha, ObjLista item) {
    setState(() {
      final lista = matrizDeListas[linha];
      final idx = lista.indexOf(item);
      if (idx != -1) {
        lista.removeAt(idx);
      }

      if (lista.isEmpty) {
        matrizDeListas.removeAt(linha);
        docIds.removeAt(linha);
        tituloControllers.removeAt(linha);
        return;
      }

      for (var i = 0; i < lista.length; i++) {
        lista[i].posicao = i;
      }
    });
  }

  Future<void> confirmarSalvarLista(int linha) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar salvamento"),
        content: const Text("Deseja salvar as alterações desta lista?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await salvarLista(linha);
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
            onPressed: aumentarLinha,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => confirmarSalvarLista(linha),
                            child: const Text("Salvar lista"),
                          ),
                        ),
                        TextField(
                          controller: tituloControllers[linha],
                          decoration: const InputDecoration(
                            hintText: "Título da lista",
                          ),
                        ),
                        ...sublista.map((item) {
                          return Column(
                            key: ValueKey(item), // chave estável por referência
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: item.check,
                                    onChanged: (v) =>
                                        setState(() => item.check = v!),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: item.controller,
                                      onChanged: (v) => item.texto = v,
                                      decoration: InputDecoration(
                                        hintText: "Item ${item.posicao}",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_a_photo_outlined),
                                    tooltip: "Adicionar imagem",
                                    onPressed: () async {
                                      final img = await escolherImagem(context);
                                      if (img != null) {
                                        setState(() => item.adicionarImagem(img));
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    tooltip: "Apagar item",
                                    onPressed: () => removerItemLocal(linha, item),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Imagens novas (XFile)
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

                              // Imagens já salvas (URLs)
                              if (item.urlsSalvas.isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.urlsSalvas.length,
                                    itemBuilder: (_, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            item.urlsSalvas[i],
                                            height: 100,
                                            fit: BoxFit.cover,
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
                              onPressed: () => aumentarColunas(linha),
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
