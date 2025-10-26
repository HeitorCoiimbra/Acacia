import 'package:flutter/material.dart';

class RepensarPensamento extends StatelessWidget {
  const RepensarPensamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reavaliar pensamentos"),
        backgroundColor: Colors.amberAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Durante uma crise, surgem pensamentos automáticos e negativos.\n\n"
          "Tente questionar:\n"
          "• Há provas reais disso?\n"
          "• Já enfrentei isso antes?\n"
          "• O que posso fazer agora?\n\n"
          "Essas perguntas ajudam a desafiar pensamentos disfuncionais e trazer clareza emocional.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
