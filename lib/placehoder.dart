import 'package:flutter/material.dart';

//Usada somente para que guarde um lugar e não acabe dando erro no código
class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.amberAccent,
      title: const Text("Placeholder"),
      ),
      body: Center(
        child: const Text("Só pra não quebrer e ter que atualizar"),
      ),
    );
  }
}