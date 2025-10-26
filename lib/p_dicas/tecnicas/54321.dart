import 'package:flutter/material.dart';

class Distratibilidade54321 extends StatelessWidget {
  const Distratibilidade54321({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Técnica 5-4-3-2-1"),
        backgroundColor: Colors.amberAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Essa técnica grounding ajuda a reconectar com o momento presente.\n\n"
          "Observe e diga para si mesmo:\n"
          "• 5 coisas que você pode ver\n"
          "• 4 coisas que você pode tocar\n"
          "• 3 coisas que pode ouvir\n"
          "• 2 coisas que pode cheirar\n"
          "• 1 coisa que pode saborear\n\n"
          "Essa contagem progressiva diminui a intensidade da crise e traz sua mente de volta ao agora.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
