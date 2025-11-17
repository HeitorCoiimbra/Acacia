import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DistratibilidadeObjetos extends StatefulWidget {
  const DistratibilidadeObjetos({super.key});

  @override
  State<DistratibilidadeObjetos> createState() =>
      _DistratibilidadeObjetosState();
}

class _DistratibilidadeObjetosState extends State<DistratibilidadeObjetos>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _emExecucao = false;
  String mensagem = "Toque em 'Iniciar exercício' para começar";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // ritmo ~60 BPM
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        await _playSound();
        setState(() {
          mensagem = "🟢 Nomeie algo do ambiente";
        });
      }
    });

    _controller.addListener(() {
      if (_controller.value == 0.0 || _controller.value == 1.0) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && _emExecucao) {
            setState(() {
              mensagem = "🌿 Observe o ritmo...";
            });
          }
        });
      }
    });
  }

  Future<void> _playSound() async {
    try {
      // 🔹 Garante que o player reinicie corretamente o som
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sons/sino.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint("Erro ao tocar som: $e");
    }
  }

  void _iniciarExercicio() {
    setState(() {
      _emExecucao = true;
      mensagem = "🌿 Observe o ritmo...";
    });
    _controller.repeat(reverse: true);
  }

  void _finalizarExercicio() {
    setState(() {
      _emExecucao = false;
      mensagem = "✨ Exercício finalizado.";
    });
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nomear objetos ao redor"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Durante uma crise, o cérebro tende a se prender aos sintomas. "
              "Nomear objetos ao redor — como 'janela', 'parede', 'relógio' — ajuda a mudar o foco.\n\n"
              "Acompanhe o ritmo da bolinha e diga o nome de um objeto cada vez que ela tocar uma das paredes.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),

            // Área da animação
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double largura = constraints.maxWidth;
                  double raio = 30;
                  double paredeEspessura = 8;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Parede esquerda
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: paredeEspessura,
                          color: Colors.amberAccent,
                        ),
                      ),

                      // Parede direita
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: paredeEspessura,
                          color: Colors.amberAccent,
                        ),
                      ),

                      // Bolinha animada
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          double posicaoX =
                              (largura - (2 * (raio + paredeEspessura))) *
                                  _animation.value +
                              paredeEspessura;
                          return Positioned(left: posicaoX, child: child!);
                        },
                        child: CircleAvatar(
                          radius: raio,
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Mensagem
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                mensagem,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Botão iniciar/finalizar
            ElevatedButton.icon(
              onPressed: _emExecucao ? _finalizarExercicio : _iniciarExercicio,
              icon: Icon(_emExecucao ? Icons.stop : Icons.play_arrow),
              label: Text(
                _emExecucao ? "Finalizar exercício" : "Iniciar exercício",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _emExecucao
                    ? Colors.redAccent
                    : Colors.amberAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
