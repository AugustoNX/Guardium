import 'package:flutter/material.dart';
import 'package:vigilancia_app/screens/relatorios/detalhes_mes_screen.dart';
import 'package:intl/intl.dart';

class FechamentoMesScreen extends StatefulWidget {
  const FechamentoMesScreen({super.key});

  @override
  State<FechamentoMesScreen> createState() => _FechamentoMesScreenState();
}

class _FechamentoMesScreenState extends State<FechamentoMesScreen> {
  String _anoSelecionado = DateTime.now().year.toString();

  List<Map<String, dynamic>> get _meses {
    final meses = [
      {'nome': 'Janeiro', 'numero': 1},
      {'nome': 'Fevereiro', 'numero': 2},
      {'nome': 'Março', 'numero': 3},
      {'nome': 'Abril', 'numero': 4},
      {'nome': 'Maio', 'numero': 5},
      {'nome': 'Junho', 'numero': 6},
      {'nome': 'Julho', 'numero': 7},
      {'nome': 'Agosto', 'numero': 8},
      {'nome': 'Setembro', 'numero': 9},
      {'nome': 'Outubro', 'numero': 10},
      {'nome': 'Novembro', 'numero': 11},
      {'nome': 'Dezembro', 'numero': 12},
    ];

    return meses.map((mes) {
      final mesAno = '$_anoSelecionado-${mes['numero'].toString().padLeft(2, '0')}';
      return {
        'nome': mes['nome'],
        'numero': mes['numero'],
        'mesAno': mesAno,
        'nomeCompleto': '${mes['nome']} $_anoSelecionado',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fechamento do mês'),
        actions: [
          DropdownButton<String>(
            value: _anoSelecionado,
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white),
            items: List.generate(5, (index) {
              final ano = DateTime.now().year - index;
              return DropdownMenuItem<String>(
                value: ano.toString(),
                child: Text(ano.toString()),
              );
            }),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _anoSelecionado = newValue;
                });
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Seletor de ano
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Text(
                      'Ano: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _anoSelecionado,
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista de meses
            Expanded(
              child: ListView.builder(
                itemCount: _meses.length,
                itemBuilder: (context, index) {
                  final mes = _meses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        mes['nomeCompleto'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesMesScreen(
                              mesAno: mes['mesAno'],
                              nomeMes: mes['nomeCompleto'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
