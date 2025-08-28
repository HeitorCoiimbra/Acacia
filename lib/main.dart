import 'package:acacia/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:acacia/tela_principal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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