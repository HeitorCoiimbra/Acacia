import 'package:acacia/p_diario.dart';
import 'package:acacia/p_lista.dart';
import 'package:flutter/material.dart';

//Cria uma primeira camada visual e os botões de navegação na parte inferior da tela
//e é onde o usuário consegue mudar de uma página para a outra
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  var paginaAtual = 0;
  var paginas = const [Lista(), Diario(), Placeholder()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acácia"),
        backgroundColor: const Color.fromRGBO(255, 215, 64, 1),
      ),
      body: Center(
        child: paginas.elementAt(paginaAtual),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[
          
          BottomNavigationBarItem(icon: Icon(Icons.list),
          label: "Listas"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month),
          label: "Diario"),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
          label: "Placeholder"),
        ],
        currentIndex: paginaAtual,
        fixedColor: Colors.blueAccent,
        onTap: (int inIndex) {
          setState(() { 
            paginaAtual = inIndex;
          });
        },
      ),
    );
  }
}