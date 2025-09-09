import 'package:acacia/cadastro/authentication.dart';
import 'package:acacia/cadastro/login.dart';
import 'package:acacia/p_diario/diario.dart';
import 'package:acacia/p_lista/lista.dart';
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
  var paginas = const [Lista(), Diario(), Placeholder(), Login()];
  bool logado = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acácia", style: TextStyle(fontSize: 20)),
        backgroundColor: const Color.fromRGBO(255, 215, 64, 1),
        actions: [
          Align(
            alignment: Alignment(0, 0),
            child: logado
                ? Container(
                    width: 47,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      image: DecorationImage(
                        image: AssetImage("../assets/AcaciaLogo.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final resultado = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                      if (resultado == true) {
                        setState(() {
                          logado = true;
                        });
                      }
                    },
                    child: Text("Login"),
                  ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(child: paginas.elementAt(paginaAtual)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amberAccent.shade100,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Diario",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Placeholder",
          ),
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
