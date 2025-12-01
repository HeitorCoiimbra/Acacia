import 'dart:async';
import 'package:flutter/material.dart';

class RespiracaoControlada extends StatefulWidget {
  const RespiracaoControlada({super.key});

  @override
  State<RespiracaoControlada> createState() => _RespiracaoControladaState();
}

class _RespiracaoControladaState extends State<RespiracaoControlada> {
  final Color corPrincipal = Colors.amberAccent;

  bool iniciado = false;
  int tempo = 1;
  String instrucao = "Quando estiver pronto, toque em Iniciar.";
  Timer? timer;
  int fase = 0; // 0 = inspirar (1s) | 1 = expirar (3s)
  double progresso = 0; // 0 a 1 para animar o círculo

  void iniciarExercicio() {
    setState(() {
      iniciado = true;
      instrucao = "Inspire suavemente pelo nariz";
      tempo = 1;
      fase = 0;
      progresso = 0;
    });

    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        // quanto cada tick representa
        double passo = fase == 0 ? 0.1 : 0.02; 

        if (fase == 0) {
          // Inspirar (encher)
          progresso += passo;
          if (progresso >= 1) {
            fase = 1;
            instrucao = "Solte o ar devagar pela boca";
          }
        } else {
          // Expirar (esvaziar)
          progresso -= passo;
          if (progresso <= 0) {
            fase = 0;
            instrucao = "Inspire suavemente pelo nariz";
          }
        }
      });
    });
  }

  void parar() {
    timer?.cancel();
    setState(() {
      iniciado = false;
      instrucao = "Quando estiver pronto, toque em Iniciar.";
      fase = 0;
      progresso = 0;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrincipal,
        title: const Text("Respiração Controlada"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iniciado)
              Column(
                children: const [
                  Center(
                    child: Row(
                      children: [
                        Icon(Icons.air, size: 40, color: Colors.amber),
                        SizedBox(width: 10),
                        Text(
                          "Respiração Controlada",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Ajuda o corpo a acalmar.\n"
                    "Respire assim:\n"
                    "• Inspire curto (1s)\n"
                    "• Solte devagar (5s)\n"
                    "Siga o ritmo na tela.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                ],
              ),

            Text(
              instrucao,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Cronômetro + anel
            Stack(
              alignment: Alignment.center,
              children: [
                if (iniciado)
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: CircularProgressIndicator(
                      value: progresso.clamp(0, 1),
                      strokeWidth: 8,
                      color: Colors.amber,
                      backgroundColor: Colors.amber.shade100,
                    ),
                  ),

                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ],
                  ),
                  child: Text(
                    fase == 0
                        ? (1 - progresso).clamp(0, 1).toStringAsFixed(1)
                        : (progresso).clamp(0, 1).toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: iniciado ? parar : iniciarExercicio,
              icon: Icon(iniciado ? Icons.stop : Icons.play_arrow),
              label: Text(iniciado ? "Parar exercício" : "Iniciar exercício"),
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrincipal,
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
