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

## Configuração do Firebase

### 1. Configurar o Projeto Firebase

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Crie um novo projeto ou use o existente: `vigilancia-d4457`
3. Ative o **Authentication** com provedor Email/Senha
4. Ative o **Realtime Database** com a URL: `https://vigilancia-d4457-default-rtdb.firebaseio.com/`

### 2. Configurar Regras de Segurança

No Realtime Database, configure as regras de segurança:

```json
{
  "rules": {
    "usuarios": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid",
        "clientes": {
          ".read": "auth != null && auth.uid == $uid",
          ".write": "auth != null && auth.uid == $uid"
        }
      }
    }
  }
}
```

### 3. Configurar o Aplicativo

1. Baixe o arquivo `google-services.json` (Android) ou `GoogleService-Info.plist` (iOS) do console do Firebase
2. Coloque o arquivo na pasta apropriada:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 4. Atualizar as Configurações

Edite o arquivo `lib/firebase_options.dart` com as configurações reais do seu projeto Firebase.

## Estrutura do Banco de Dados

```json
{
  "usuarios": {
    "uidUsuario": {
      "nome": "João",
      "email": "joao@email.com",
      "clientes": {
        "idCliente1": {
          "nome": "Maria",
          "telefone": "99999-9999",
          "cidade": "Maringá",
          "rua": "Rua A",
          "bairro": "Centro",
          "numero": "100",
          "modalidade": "Residencial",
          "valor": 150.0,
          "statusPagamento": {
            "2025-03": true,
            "2025-04": false
          }
        }
      }
    }
  }
}
```

## Como Executar

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Configurar Firebase** (seguir instruções acima)

3. **Executar o aplicativo**:
   ```bash
   flutter run
   ```

## Telas do Aplicativo

1. **Login** - Autenticação do usuário
2. **Cadastro** - Criação de nova conta
3. **Home** - Tela principal com atalhos
4. **Cadastro de Cliente** - Formulário para novos clientes
5. **Lista de Clientes** - Visualização e gerenciamento
6. **Fechamento do Mês** - Seleção de mês para relatórios
7. **Detalhes do Mês** - Relatório detalhado
8. **Pendências** - Clientes inadimplentes

## Segurança

- Cada usuário só pode acessar seus próprios dados
- Autenticação obrigatória para todas as operações
- Regras de segurança configuradas no Firebase
- Validação de dados no frontend e backend

## Dependências Principais

- `firebase_core`: ^2.24.2
- `firebase_auth`: ^4.15.3
- `firebase_database`: ^10.4.0
- `google_fonts`: ^6.1.0
- `intl`: ^0.19.0

## Suporte

Para dúvidas ou problemas, verifique:
1. Se o Firebase está configurado corretamente
2. Se as regras de segurança estão aplicadas
3. Se os arquivos de configuração estão no local correto
4. Se as dependências foram instaladas (`flutter pub get`)
