import 'package:acacia/funcoes_multiplataforma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Anotacao extends StatefulWidget {
  final DateTime dia;
  const Anotacao({Key? key, required this.dia}) : super(key: key);

  @override
  State<Anotacao> createState() => _AnotacaoState();
}

class _AnotacaoState extends State<Anotacao> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get _userAnotacoesCol =>
      firestore.collection('users').doc(_uid).collection('anotacoes');

  final List<String> emocoes = ["😊", "😢", "😡", "😴"];
  String emocaoSelecionada = "";

  final TextEditingController _textoController = TextEditingController();

  String pasta = "diario";

  // Apenas imagens escolhidas pelo usuário (XFile); não exibimos URLs salvas nesta tela
  List<XFile> imagens = [];

  final List<String> perguntasPadroes = [
    'O que me deixou ansioso hoje?',
    'Como eu tentei me acalmar?',
    'Que pensamento se repetiu?',
    'Pelo que sou grato hoje?',
  ];
  final Map<String, String> reflexoes = {};

  @override
  Widget build(BuildContext context) {
    final hojeFmt = DateFormat('dd/MM/yyyy').format(widget.dia);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Anotação do dia"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Cabeçalho com data e botão salvar
              Row(
                children: [
                  Text(
                    hojeFmt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _registrarAnotacao,
                    child: const Text("Salvar"),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Emoções
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: emocoes.map((e) {
                  final val = e == "😊"
                      ? "feliz"
                      : e == "😢"
                      ? "triste"
                      : e == "😡"
                      ? "raiva"
                      : "tedio";
                  return IconButton(
                    onPressed: () => setState(() => emocaoSelecionada = val),
                    icon: Text(e, style: const TextStyle(fontSize: 30)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Texto principal
              TextFormField(
                controller: _textoController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Escreva seus pensamentos aqui...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo vazio' : null,
              ),
              const SizedBox(height: 16),

              // Reflexões (lista e botão)
              if (reflexoes.isNotEmpty) ...[
                Text(
                  "Reflexões (${reflexoes.length}):",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: reflexoes.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.amberAccent,
                            ),
                            onPressed: () =>
                                _abrirDialogoReflexao(editQuestion: entry.key),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                reflexoes.remove(entry.key);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reflexão removida"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirDialogoReflexao(),
                  icon: const Icon(Icons.question_answer),
                  label: const Text("Adicionar Reflexão"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão de imagens
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final img = await escolherImagem(context);
                    if (img != null) setState(() => imagens.add(img));
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Adicionar imagem"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Mostrar apenas as imagens que serão enviadas
              if (imagens.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagens.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: mostrarImagem(imagens[i], altura: 100),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirDialogoReflexao({String? editQuestion}) {
    final isEdit = editQuestion != null;
    String? selectedPergunta = editQuestion;
    final respostaController = TextEditingController(
      text: isEdit ? reflexoes[editQuestion] : '',
    );
    final localPerguntas = List<String>.from(perguntasPadroes);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctxDialog, setStateDialog) {
          final available = localPerguntas
              .where((p) => p == editQuestion || !reflexoes.containsKey(p))
              .toList();

          return AlertDialog(
            title: Text(isEdit ? 'Editar Reflexão' : 'Nova Reflexão'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedPergunta,
                    hint: const Text("Selecione uma reflexão"),
                    items: available
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) => setStateDialog(() {
                      selectedPergunta = v;
                      respostaController.text = v != null
                          ? (reflexoes[v] ?? '')
                          : '';
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: respostaController,
                    decoration: const InputDecoration(labelText: "Resposta"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      final novaPerguntaController = TextEditingController();
                      showDialog(
                        context: ctxDialog,
                        builder: (ctx2) => AlertDialog(
                          title: const Text('Pergunta Personalizada'),
                          content: TextField(
                            controller: novaPerguntaController,
                            decoration: const InputDecoration(
                              labelText: 'Pergunta',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx2),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final p = novaPerguntaController.text.trim();
                                if (p.isNotEmpty &&
                                    !localPerguntas.contains(p)) {
                                  setStateDialog(() {
                                    localPerguntas.add(p);
                                    selectedPergunta = p;
                                    respostaController.clear();
                                  });
                                }
                                Navigator.pop(ctx2);
                              },
                              child: const Text('Adicionar'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("Personalizar reflexão"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctxDialog),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  final p = selectedPergunta;
                  final r = respostaController.text.trim();
                  if (p != null && r.isNotEmpty) {
                    setState(() {
                      if (!perguntasPadroes.contains(p)) {
                        perguntasPadroes.add(p);
                      }
                      reflexoes[p] = r;
                    });
                    Navigator.pop(ctxDialog);
                  }
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _registrarAnotacao() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Upload das imagens novas e coleta das URLs
      final List<String> urlsFinais = [];
      for (final img in imagens) {
        final url = await uploadImagem(img, pasta: pasta);
        if (url != null && url.isNotEmpty) {
          urlsFinais.add(url);
        }
      }

      final dataDoc = {
        'texto': _textoController.text,
        'data': Timestamp.fromDate(widget.dia),
        'emocao': emocaoSelecionada.isNotEmpty ? emocaoSelecionada : null,
        'temReflexoes': reflexoes.isNotEmpty,
        'perguntas': reflexoes.keys.toList(),
        'imagens': urlsFinais, // salva as URLs das imagens enviadas
      };

      final docRef = await _userAnotacoesCol.add(dataDoc);

      // Salva reflexões como subcoleção (se houver)
      for (var entry in reflexoes.entries) {
        await docRef.collection('reflexoes').add({
          'pergunta': entry.key,
          'resposta': entry.value,
        });
      }

      // Limpa o estado local (imagens escolhidas) após salvar
      setState(() {
        imagens.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anotação registrada com sucesso")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e")));
    }
  }
}
