import 'package:flutter/material.dart';

class Tecnica54321 extends StatefulWidget {
  const Tecnica54321({super.key});

  @override
  State<Tecnica54321> createState() => _Tecnica54321State();
}

class _Tecnica54321State extends State<Tecnica54321> {
  int etapaAtual = -1; 
  final Color corPrincipal = Colors.amberAccent;

  final List<Map<String, String>> etapas = [
    {
      'titulo': '5 coisas que você pode VER 👀',
      'descricao':
          'Olhe ao seu redor e observe cinco coisas que você pode ver. Pode ser qualquer detalhe: uma cor, um objeto, uma luz...'
    },
    {
      'titulo': '4 coisas que você pode TOCAR ✋',
      'descricao':
          'Toque em quatro coisas diferentes próximas de você. Sinta a textura, a temperatura, o peso...'
    },
    {
      'titulo': '3 coisas que você pode OUVIR 👂',
      'descricao':
          'Preste atenção aos sons ao seu redor. Tente identificar três sons diferentes, próximos ou distantes.'
    },
    {
      'titulo': '2 coisas que você pode CHEIRAR 👃',
      'descricao':
          'Sinta o ar e perceba dois cheiros que você consegue identificar agora.'
    },
    {
      'titulo': '1 coisa que você pode SABOREAR 👅',
      'descricao':
          'Perceba o sabor que está na sua boca, ou imagine algo que gosta de saborear.'
    },
  ];

  void avancarEtapa() {
    setState(() {
      if (etapaAtual < etapas.length) {
        etapaAtual++;
      }
    });
  }

  void reiniciar() {
    setState(() {
      etapaAtual = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool terminou = etapaAtual >= etapas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnica 5-4-3-2-1'),
        backgroundColor: corPrincipal,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: etapaAtual == -1
            ? _telaInicial()
            : terminou
                ? _telaFinal()
                : _telaEtapa(),
      ),
    );
  }

  // 🟡 Tela inicial com explicação e botão "Iniciar"
  Widget _telaInicial() {
    return Padding(
      key: const ValueKey('inicio'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.self_improvement, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              'Técnica 5-4-3-2-1',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Essa técnica ajuda você a se reconectar com o momento presente durante momentos de ansiedade. '
              'Vamos passar juntos pelas etapas de observação dos sentidos: visão, tato, audição, olfato e paladar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: avancarEtapa,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar exercício'),
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌿 Tela de cada etapa
  Widget _telaEtapa() {
    return Padding(
      key: const ValueKey('etapa'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              etapas[etapaAtual]['titulo']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              etapas[etapaAtual]['descricao']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: avancarEtapa,
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: Text(
                etapaAtual == etapas.length - 1 ? 'Concluir' : 'Próximo',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                etapas.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= etapaAtual
                        ? Colors.amber
                        : Colors.amber.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ Tela final com mensagem e opção de reiniciar
  Widget _telaFinal() {
    return Padding(
      key: const ValueKey('final'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.teal, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Você concluiu o exercício!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Perceba como se sente agora. Respire fundo e siga com calma.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: reiniciar,
              icon: const Icon(Icons.replay),
              label: const Text('Voltar ao início'),
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
