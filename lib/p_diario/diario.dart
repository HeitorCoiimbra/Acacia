import 'package:acacia/p_diario/add_anotacao.dart';
import 'package:acacia/p_diario/listagem_anotacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//Página que tem como objetivo criar um diário virtual, onde o usuário pode usar para
//anotar coisas do dia a dia ou até mesmo qualquer coisa que possa vir a causar ansiedade,
//assim anotando e conhecendo melhor o que pode ser um gatilho e com o que pode ajudar
//a lidar com essas coisas

//Ainda não está completo, apenas leva para a página de anotações
class Diario extends StatefulWidget {
  const Diario({super.key});

  @override
  State<Diario> createState() => _DiarioState();
}

class _DiarioState extends State<Diario> {
  DateTime diaFoco = DateTime.now();
  DateTime? diaSelecionado;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Diário", style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: TableCalendar(
                focusedDay: diaSelecionado ?? diaFoco,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),

                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.amberAccent,
                    shape: BoxShape.circle,
                  ),
                ),

                selectedDayPredicate: (day) {
                  return isSameDay(diaSelecionado, day);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    diaSelecionado = selectedDay;
                    diaFoco = focusedDay;

                    if (diaFoco.day <= DateTime.now().day) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Anotacao(dia: diaFoco),
                        ),
                      );
                    }
                  });
                },
              ),
            ),
          ),
          ElevatedButton(onPressed: () => listarTodas(context), child: Text("Listar anotações"))
        ],
      ),
    );
  }

  Future<void> _executaConsulta(
    BuildContext context,
    Query<Map<String, dynamic>> query,
  ) async {
    var snapshot = await query.get();
    List<Map<String, dynamic>> anotacoes = snapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();
    _listarAnotacoes(context, anotacoes);
  }

  void _listarAnotacoes(
    BuildContext context,
    List<Map<String, dynamic>> anotacoes,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListagemAnotacoes(anotacoes: anotacoes),
      ),
    );
  }

  void listarTodas(BuildContext context){
    _executaConsulta(context, firestore.collection('anotacoes'));
  }
}
