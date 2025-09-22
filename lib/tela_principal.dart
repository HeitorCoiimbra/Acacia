import 'package:acacia/cadastro/authentication.dart';
import 'package:acacia/p_diario/diario.dart';
import 'package:acacia/p_lista/lista.dart';
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:flutter/material.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;
  final paginas = const [Lista(), Diario(), Placeholder()];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;  

    return Scaffold(
      appBar: AppBar(
        title: Text("Acácia", style: TextStyle(fontSize: 20)),
        backgroundColor: const Color.fromRGBO(255, 215, 64, 1),
        actions: [
          if (user != null)                                               
            GestureDetector(
              onTap: () => AuthenticationHelper().signOut(),
              child: Container(
                width: 47,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(16),
                  image: DecorationImage(
                    image: AssetImage("../assets/AcaciaLogo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(child: paginas[paginaAtual]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amberAccent.shade100,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Diário",
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
