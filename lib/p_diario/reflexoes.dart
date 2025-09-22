import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class Reflexoes extends StatelessWidget {
  final String anotacaoId;
  const Reflexoes({required this.anotacaoId, Key? key}) : super(key: key);

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> get _streamReflexoes =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('anotacoes')
          .doc(anotacaoId)
          .collection('reflexoes')
          .orderBy('pergunta')
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflexões Respondidas'),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _streamReflexoes,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma reflexão encontrada.'));
          }

          final docs = snap.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data();
              final pergunta = data['pergunta'] as String? ?? '';
              final resposta = data['resposta'] as String? ?? '';
              return ListTile(
                title: Text(
                  pergunta,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(resposta),
              );
            },
          );
        },
      ),
    );
  }
}
