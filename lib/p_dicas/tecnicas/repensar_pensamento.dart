import 'package:flutter/material.dart';

class RepensarPensamento extends StatefulWidget {
  const RepensarPensamento({super.key});

  @override
  State<RepensarPensamento> createState() => _RepensarPensamentoState();
}

class _RepensarPensamentoState extends State<RepensarPensamento> {
  int etapa = 0;

  final pensamentoCtrl = TextEditingController();
  final evidenciaCtrl = TextEditingController();
  final contraCtrl = TextEditingController();
  final novoCtrl = TextEditingController();

  @override
  void dispose() {
    pensamentoCtrl.dispose();
    evidenciaCtrl.dispose();
    contraCtrl.dispose();
    novoCtrl.dispose();
    super.dispose();
  }

  void avancar() {
    setState(() {
      etapa++;
    });
  }

  void reiniciar() {
    setState(() {
      etapa = 0;
      pensamentoCtrl.clear();
      evidenciaCtrl.clear();
      contraCtrl.clear();
      novoCtrl.clear();
    });
  }

  Widget etapaWidget({
    required String titulo,
    required String subtitulo,
    TextEditingController? ctrl,
    String botao = "Continuar",
    bool mostrarCampo = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          subtitulo,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 16),

        if (mostrarCampo)
          TextField(
            controller: ctrl,
            textAlign: TextAlign.center,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(14),
            ),
          ),

        const Spacer(),

        ElevatedButton(
          onPressed: avancar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(botao),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repensar pensamentos"),
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: () {
            switch (etapa) {
              case 0:
                return etapaWidget(
                  titulo: "Vamos olhar para um pensamento?",
                  subtitulo:
                      "Quando ficamos ansiosos, alguns pensamentos parecem muito verdadeiros.\n"
                      "Vamos observar um deles com calma e tentar enxergar de forma mais equilibrada.",
                  botao: "Começar",
                  mostrarCampo: false,
                );

              case 1:
                return etapaWidget(
                  titulo: "Qual pensamento está te incomodando?",
                  subtitulo: "Escreva o pensamento que está pesando agora.",
                  ctrl: pensamentoCtrl,
                );

              case 2:
                return etapaWidget(
                  titulo: "O que faz ele parecer real?",
                  subtitulo: "Pense nos motivos que fazem esse pensamento parecer verdade.",
                  ctrl: evidenciaCtrl,
                );

              case 3:
                return etapaWidget(
                  titulo: "Agora o outro lado",
                  subtitulo:
                      "Existe algo que sugira que esse pensamento pode não estar totalmente correto?",
                  ctrl: contraCtrl,
                );

              case 4:
                return etapaWidget(
                  titulo: "Reformule com gentileza",
                  subtitulo:
                      "Com tudo isso em mente, como você poderia pensar de uma forma mais justa consigo mesmo?",
                  ctrl: novoCtrl,
                  botao: "Finalizar",
                );

              default:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bom trabalho 🌿",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Você dedicou um momento para cuidar da sua mente. Isso importa.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: reiniciar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Refazer"),
                    ),
                  ],
                );
            }
          }(),
        ),
      ),
    );
  }
}
