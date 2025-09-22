import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';       
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'add_anotacao.dart';
import 'listagem_anotacao.dart';

class Diario extends StatefulWidget {
  const Diario({Key? key}) : super(key: key);

  @override
  State<Diario> createState() => _DiarioState();
}

class _DiarioState extends State<Diario> {
  DateTime diaFoco = DateTime.now();
  DateTime? diaSelecionado;

  String? emocaoSelecionada;
  DateTime? dataInicio;
  DateTime? dataFim;
  bool comReflexoes = false;

  final List<String> perguntasFiltro = [
    'O que me deixou ansioso hoje?',
    'Como eu tentei me acalmar?',
    'Que pensamento se repetiu?',
    'Pelo que sou grato hoje?',
  ];
  String? perguntaSelecionada;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get _userAnotacoesCol =>
      firestore.collection('users').doc(_uid).collection('anotacoes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Diário', style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: TableCalendar(
              focusedDay: diaSelecionado ?? diaFoco,
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (d) => isSameDay(d, diaSelecionado),
              onDaySelected: (sel, foc) {
                setState(() {
                  diaSelecionado = sel;
                  diaFoco = foc;
                });
                if (!sel.isAfter(DateTime.now())) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Anotacao(dia: sel)),
                  );
                }
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.amberAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _abrirFiltroSheet,
                  child: const Text('Filtros'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _listarPorFiltro(context),
                  child: const Text('Listar anotações'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirFiltroSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filtros', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: emocaoSelecionada,
                  hint: const Text('Filtrar por emoção'),
                  items: ['feliz', 'triste', 'raiva', 'tedio']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setModal(() => emocaoSelecionada = v),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final dt = await showDatePicker(
                            context: context,
                            initialDate: dataInicio ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (dt != null) setModal(() => dataInicio = dt);
                        },
                        child: Text(dataInicio == null
                            ? 'Data início'
                            : _dateFormat.format(dataInicio!)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final dt = await showDatePicker(
                            context: context,
                            initialDate: dataFim ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (dt != null) setModal(() => dataFim = dt);
                        },
                        child: Text(dataFim == null
                            ? 'Data fim'
                            : _dateFormat.format(dataFim!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  title: const Text('Somente com reflexões'),
                  value: comReflexoes,
                  onChanged: (v) => setModal(() => comReflexoes = v!),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: perguntaSelecionada,
                  hint: const Text('Filtrar por pergunta'),
                  items: perguntasFiltro
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setModal(() => perguntaSelecionada = v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _listarPorFiltro(BuildContext context) {
    Query<Map<String, dynamic>> query = _userAnotacoesCol;

    if (emocaoSelecionada != null) {
      query = query.where('emocao', isEqualTo: emocaoSelecionada);
    }
    if (dataInicio != null) {
      query = query.where(
          'data', isGreaterThanOrEqualTo: Timestamp.fromDate(dataInicio!));
    }
    if (dataFim != null) {
      query = query.where(
          'data', isLessThanOrEqualTo: Timestamp.fromDate(dataFim!));
    }
    if (comReflexoes) {
      query = query.where('temReflexoes', isEqualTo: true);
    }
    if (perguntaSelecionada != null) {
      query = query.where('perguntas', arrayContains: perguntaSelecionada);
    }

    _executaConsulta(context, query);
  }

  Future<void> _executaConsulta(
      BuildContext context, Query<Map<String, dynamic>> query) async {
    final snapshot = await query.get();
    final anotacoes = snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListagemAnotacoes(anotacoes: anotacoes),
      ),
    );
  }
}
