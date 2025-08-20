import 'package:acacia/tela_principal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
//Página que inicia tudo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Acácia App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: TelaPrincipal(),
    );
  }
}