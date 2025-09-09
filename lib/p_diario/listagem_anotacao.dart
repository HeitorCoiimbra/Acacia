import 'package:flutter/material.dart';

class ListagemAnotacoes extends StatelessWidget {
  final List<Map<String, dynamic>> anotacoes;
  const ListagemAnotacoes({super.key, required this.anotacoes});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Listagem das anotações")),
      body: ListView.builder(
        itemCount: anotacoes.length,
        itemBuilder: (context, index) {
          var anotacao = anotacoes[index];
          return ListTile(
            title: Text("Dia: ${anotacao['dia'] ?? 'Algum dia ai'},"),
            subtitle: Text("Emoção: ${anotacao['emocao'] ?? 'N/A'}, Anotação: ${anotacao['texto'] ?? 'Nada foi escrito'}"),
          );
        },
      ),
    );
  }
}