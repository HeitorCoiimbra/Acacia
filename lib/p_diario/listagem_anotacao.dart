import 'package:acacia/p_diario/reflexoes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListagemAnotacoes extends StatelessWidget {
  final List<Map<String, dynamic>> anotacoes;
  const ListagemAnotacoes({super.key, required this.anotacoes});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Listagem das Anotações"),
      ),
      body: ListView.builder(
        itemCount: anotacoes.length,
        itemBuilder: (context, index) {
          final a = anotacoes[index];
          final ts = a['data'] as Timestamp?;
          final data = ts != null ? ts.toDate() : DateTime.now();
          final dataFmt = fmt.format(data);

          final imagens = List<String>.from(a['imagens'] ?? []);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com data
                  Row(
                    children: [
                      Text(
                        "Dia: $dataFmt",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.local_activity,
                            color: Colors.amberAccent),
                        tooltip: "Ver reflexões",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Reflexoes(anotacaoId: a['id']),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Emoção
                  Text(
                    "Emoção: ${a['emocao'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),

                  // Texto da anotação
                  Text(
                    a['texto'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Reflexões
                  Text(
                    "Possui reflexão: ${a['temReflexoes'] ? 'Sim' : 'Não'}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Imagens salvas
                  if (imagens.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagens.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imagens[i],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
