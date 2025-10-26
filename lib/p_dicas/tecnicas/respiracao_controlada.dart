import 'package:flutter/material.dart';

class RespiracaoControlada extends StatelessWidget {
  const RespiracaoControlada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Respiração controlada"),
        backgroundColor: Colors.amberAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "A respiração é uma ferramenta poderosa para reduzir a ansiedade.\n\n"
          "Experimente:\n"
          "1️⃣ Inspire pelo nariz por 4 segundos\n"
          "2️⃣ Segure por 7 segundos\n"
          "3️⃣ Solte o ar pela boca lentamente por 8 segundos\n\n"
          "Isso regula o oxigênio no corpo e desacelera o ritmo cardíaco, trazendo calma.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
