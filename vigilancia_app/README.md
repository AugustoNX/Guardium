# Aplicativo de Controle de Orçamento - Empresa de Vigilância

Este é um aplicativo Flutter desenvolvido para controle de orçamento de uma empresa de vigilância, substituindo registros manuais por uma aplicação digital integrada ao Firebase.

## Funcionalidades

### Autenticação
- Login com email e senha
- Cadastro de novos usuários
- Recuperação de senha
- Isolamento de dados por usuário (cada usuário vê apenas seus próprios dados)

### Gestão de Clientes
- Cadastro completo de clientes (nome, telefone, endereço, modalidade, valor)
- Lista de clientes com filtros e busca
- Edição e exclusão de clientes
- Controle de status de pagamento por mês

### Relatórios e Controle Financeiro
- Fechamento mensal com relatórios detalhados
- Controle de pendências (clientes inadimplentes)
- Estatísticas de pagamento
- Valores recebidos e pendentes por mês

## Tecnologias Utilizadas

- **Frontend**: Flutter + Dart
- **Backend**: Firebase Realtime Database + Firebase Authentication
- **Tema**: Interface escura seguindo o design fornecido
