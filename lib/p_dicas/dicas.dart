import 'package:flutter/material.dart';
import 'tecnicas/objetos.dart';
import 'tecnicas/54321.dart';
import 'tecnicas/respiracao_controlada.dart';
import 'tecnicas/repensar_pensamento.dart';

class Dicas extends StatelessWidget {
  const Dicas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnicas e Dicas para Ansiedade'),
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Aqui você encontra técnicas simples e comprovadas para lidar com a ansiedade. "
            "Elas funcionam melhor quando praticadas com frequência — não apenas em momentos de crise. "
            "A prática regular ajuda o corpo e a mente a reconhecerem os sinais e reagirem com mais calma.",
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          const Text(
            "💡 Lembre-se: pratique com atenção plena. Observe sua respiração e as sensações do corpo. "
            "Se a mente se distrair, apenas perceba e volte ao foco, sem julgamentos.",
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              height: 1.4,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 25),

          // Seção: Distratibilidade
          const Text(
            "Distratibilidade",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tecnicaCard(
                context,
                "Nomear objetos",
                "Redireciona o foco para o ambiente e reduz o impacto dos sintomas.",
                const DistratibilidadeObjetos(),
              ),
              _tecnicaCard(
                context,
                "Técnica 5-4-3-2-1",
                "Ajuda a reconectar-se com o momento presente através dos sentidos.",
                const Distratibilidade54321(),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Seção: Respiração
          const Text(
            "Respiração",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tecnicaCard(
                context,
                "Respiração controlada",
                "Acalma corpo e mente, auxiliando no controle fisiológico da ansiedade.",
                const RespiracaoControlada(),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Seção: Repensar Pensamento
          const Text(
            "Repensar Pensamento",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tecnicaCard(
                context,
                "Reavaliar pensamentos",
                "Ajuda a identificar padrões automáticos e substituí-los por ideias mais realistas.",
                const RepensarPensamento(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tecnicaCard(
    BuildContext context,
    String titulo,
    String descricao,
    Widget destino,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => destino),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  descricao,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
