import 'package:flutter/material.dart';
import 'package:vigilancia_app/services/auth_service.dart';
import 'package:vigilancia_app/services/database_service.dart';
import 'package:intl/intl.dart';

class DetalhesMesScreen extends StatefulWidget {
  final String mesAno;
  final String nomeMes;

  const DetalhesMesScreen({
    super.key,
    required this.mesAno,
    required this.nomeMes,
  });

  @override
  State<DetalhesMesScreen> createState() => _DetalhesMesScreenState();
}

class _DetalhesMesScreenState extends State<DetalhesMesScreen> {
  final _databaseService = DatabaseService();
  final _authService = AuthService();
  Map<String, dynamic>? _relatorio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRelatorio();
  }

  Future<void> _carregarRelatorio() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user != null) {
        final relatorio = await _databaseService.getRelatorioMes(user.uid, widget.mesAno);
        setState(() {
          _relatorio = relatorio;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar relatório: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeMes),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _relatorio == null
              ? const Center(
                  child: Text(
                    'Erro ao carregar relatório',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cards de informações
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Resumo do Mês',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      'Total de clientes',
                                      _relatorio!['totalClientes'].toString(),
                                      Icons.people,
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildInfoCard(
                                      'Novos clientes',
                                      '0', // TODO: Implementar contagem de novos clientes
                                      Icons.person_add,
                                      Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              _buildInfoCard(
                                'Valor recebido',
                                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ').format(_relatorio!['valorRecebido']),
                                Icons.attach_money,
                                Colors.green,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Detalhes financeiros
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detalhes Financeiros',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              _buildFinanceRow(
                                'Valor total esperado',
                                _relatorio!['valorTotal'],
                                Colors.blue,
                              ),
                              _buildFinanceRow(
                                'Valor recebido',
                                _relatorio!['valorRecebido'],
                                Colors.green,
                              ),
                              _buildFinanceRow(
                                'Valor pendente',
                                _relatorio!['valorPendente'],
                                Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Estatísticas de pagamento
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status de Pagamento',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatusCard(
                                      'Adimplentes',
                                      _relatorio!['clientesAdimplentes'].toString(),
                                      Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildStatusCard(
                                      'Inadimplentes',
                                      _relatorio!['clientesInadimplentes'].toString(),
                                      Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Botão para ver pendências
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/pendencias',
                            arguments: widget.mesAno,
                          );
                        },
                        icon: const Icon(Icons.warning),
                        label: const Text('Ver Pendências'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ').format(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
