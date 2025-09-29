import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/cliente.dart';
import 'package:vigilancia_app/services/auth_service.dart';
import 'package:vigilancia_app/services/database_service.dart';

class CadastroClienteScreen extends StatefulWidget {
  final Cliente? cliente;
  
  const CadastroClienteScreen({super.key, this.cliente});

  @override
  State<CadastroClienteScreen> createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _valorController = TextEditingController();
  
  String _modalidadeSelecionada = 'Residencial';
  final List<String> _modalidades = [
    'Residencial',
    'Comercial',
    'Industrial',
    'Casa',
    'Apartamento',
  ];
  
  final _databaseService = DatabaseService();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _preencherCampos();
    }
  }

  void _preencherCampos() {
    final cliente = widget.cliente!;
    _nomeController.text = cliente.nome;
    _telefoneController.text = cliente.telefone;
    _cidadeController.text = cliente.cidade;
    _ruaController.text = cliente.rua;
    _bairroController.text = cliente.bairro;
    _numeroController.text = cliente.numero;
    _valorController.text = cliente.valor.toString();
    _modalidadeSelecionada = cliente.modalidade;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final cliente = Cliente(
          id: widget.cliente?.id ?? '',
          nome: _nomeController.text.trim(),
          telefone: _telefoneController.text.trim(),
          cidade: _cidadeController.text.trim(),
          rua: _ruaController.text.trim(),
          bairro: _bairroController.text.trim(),
          numero: _numeroController.text.trim(),
          modalidade: _modalidadeSelecionada,
          valor: double.parse(_valorController.text.replaceAll(',', '.')),
          statusPagamento: widget.cliente?.statusPagamento ?? {},
        );

        final user = _authService.currentUser;
        if (user != null) {
          if (widget.cliente != null) {
            await _databaseService.updateCliente(user.uid, cliente.id, cliente);
          } else {
            await _databaseService.createCliente(user.uid, cliente);
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.cliente != null 
                    ? 'Cliente atualizado com sucesso!' 
                    : 'Cliente cadastrado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar cliente: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente != null 
            ? 'Editar Cliente' 
            : 'Cadastre um novo cliente'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o telefone do cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _cidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.location_city, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite a cidade';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _ruaController,
                    decoration: const InputDecoration(
                      labelText: 'Rua',
                      prefixIcon: Icon(Icons.streetview, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite a rua';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _bairroController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      prefixIcon: Icon(Icons.location_on, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o bairro';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _numeroController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.numbers, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o número';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _modalidadeSelecionada,
                    decoration: const InputDecoration(
                      labelText: 'Modalidade',
                      prefixIcon: Icon(Icons.category, color: Colors.white70),
                    ),
                    items: _modalidades.map((String modalidade) {
                      return DropdownMenuItem<String>(
                        value: modalidade,
                        child: Text(modalidade),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _modalidadeSelecionada = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _valorController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.white70),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o valor';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Digite um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : _salvarCliente,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(widget.cliente != null ? 'Atualizar' : 'Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
