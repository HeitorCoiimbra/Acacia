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
      appBar: AppBar(title: const Text("Listagem das Anotações")),
      body: ListView.builder(
        itemCount: anotacoes.length,
        itemBuilder: (context, index) {
          final a = anotacoes[index];
          final ts = a['data'] as Timestamp?;
          final data = ts != null ? ts.toDate() : DateTime.now();
          final dataFmt = fmt.format(data);

          return ListTile(
            title: Text("Dia: $dataFmt"),
            subtitle: Text(
              "Emoção: ${a['emocao'] ?? 'N/A'}\nAnotação: ${a['texto'] ?? ''} \nPossui refleção: ${a['temReflexoes'] ? 'Sim' : 'Não'}",
            ),
            isThreeLine: true,

            trailing: IconButton(
              icon: const Icon(Icons.local_activity),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Reflexoes(anotacaoId: a['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}