# 🎓 ORBIRQ

Plataforma de Questões para Concursos Públicos

[![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=for-the-badge)](https://github.com/regyfelipe/orbirq)
[![Versão](https://img.shields.io/badge/versão-1.0.0-orange.svg?style=for-the-badge)](https://github.com/regyfelipe/orbirq/releases)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Fastify](https://img.shields.io/badge/Fastify-000000?style=for-the-badge&logo=fastify&logoColor=white)](https://fastify.io/)
[![Licença](https://img.shields.io/badge/licença-MIT-green.svg?style=for-the-badge)](LICENSE)

[Documentação Técnica](#arquitetura-do-sistema) · [Acompanhe o Progresso](https://github.com/regyfelipe/orbirq/projects)

## ⚠️ Estado Atual do Projeto

### ✅ Funcionalidades Implementadas

- 🔐 Sistema de autenticação JWT
- 📱 Interface responsiva para mobile
- 📊 Análise de desempenho
- 🔄 Sincronização offline

### 🚧 Em Desenvolvimento

- 📈 Dashboard de estatísticas avançadas
- 📚 Banco de questões em expansão
- 🤖 Recomendações personalizadas

---

## 🌟 Destaques

![Orbirq Logo](assets/white/logo.png)

### Por que escolher o Orbirq?

#### 🚀 Inovação Educacional

- Interface intuitiva e moderna
- Análise de desempenho em tempo real
- Sistema de recompensas e conquistas

#### 🎯 Foco no Aprendizado

- Banco de questões organizado
- Acompanhamento de progresso detalhado
- Estatísticas por matéria e dificuldade

#### 🤝 Colaboração

- Gerenciamento de turmas
- Acompanhamento de desempenho dos alunos
- Compartilhamento de recursos

## 🛠️ Stack Tecnológica

### Frontend (Mobile)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/BLoC-02569B?style=for-the-badge)](https://bloclibrary.dev/)
[![Provider](https://img.shields.io/badge/Provider-4CAF50?style=for-the-badge)](https://pub.dev/packages/provider)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org/)

### Backend (API)

[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Fastify](https://img.shields.io/badge/Fastify-000000?style=for-the-badge&logo=fastify&logoColor=white)](https://fastify.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)](https://jwt.io/)

## 📱 Telas

| Login | Dashboard | Banco de Questões |
|-------|-----------|-------------------|
| ![Login](images/login.jpg) | ![Dashboard](images/home.jpg) | ![Questões](images/questions.jpg) |


## 🎯 Recursos por Perfil

### 👨‍🎓 Alunos

| Recurso | Descrição |
|---------|-----------|
| 📊 Dashboard | Visão geral personalizada de desempenho |
| 📚 Questões | Banco de questões organizado por matéria |
| 📈 Estatísticas | Análise detalhada de desempenho |
| 🏆 Conquistas | Gamificação do aprendizado |

### 👨‍🏫 Professores

| Recurso | Descrição |
|---------|-----------|
| 📊 Turmas | Gerenciamento de turmas e alunos |
| 📝 Questões | Criação e gerenciamento de questões |
| 📈 Análise | Estatísticas de desempenho da turma |
| 📋 Relatórios | Geração de relatórios de progresso |

## 🚀 Começando

### Pré-requisitos

```bash
# Verifique a versão do Flutter (3.8.1 ou superior)
flutter --version

# Verifique as dependências
flutter doctor
```

### Configuração do Ambiente

### 1. Clone e Instale

```bash
# Clone o repositório
git clone https://github.com/regyfelipe/orbirq.git

# Entre no diretório
cd orbirq

# Instale as dependências
flutter pub get
```

### 2. Configure o Ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Configure as variáveis de ambiente no .env
# Configurações do Banco de Dados
DATABASE_URL=postgresql://usuario:senha@localhost:5432/orbirq

# Configurações de Autenticação
JWT_SECRET=sua_chave_secreta_jwt
JWT_EXPIRES_IN=7d

# Configurações do Servidor
PORT=3000
NODE_ENV=development
```

### 3. Execute o App

```bash
# Modo debug
flutter run

# Modo release
flutter run --release
```

## 📊 Arquitetura do Sistema

### Frontend (Flutter)

```mermaid
graph TD
    A[Interface do Usuário] --> B[BLoC / Provider]
    B --> C[Repositórios Locais]
    C --> D[SQLite]
    B --> E[API Client]
    E --> F[Backend API]
```

### Backend (Node.js + Fastify)

```mermaid
graph TD
    A[API REST] --> B[Controladores]
    B --> C[Serviços]
    C --> D[Repositórios]
    D --> E[PostgreSQL]
    A --> F[Autenticação JWT]
    C --> G[Lógica de Negócios]
```

## 🤝 Contribuindo

Adoramos receber contribuições! Veja nosso [Guia de Contribuição](CONTRIBUTING.md) para começar.

### Fluxo de Trabalho

1. 🍴 Fork o projeto
2. 🔄 Sincronize com o repositório principal
3. 👨‍💻 Desenvolva suas alterações
4. 🧪 Teste tudo
5. 📝 Atualize a documentação
6. 🔍 Abra um PR

## 📞 Suporte

[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/orbirq)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://wa.me/55992801698)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:contato@orbirq.com)

## 📄 Licença

Copyright © 2024 Orbirq

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

### Feito com 💚 pela Equipe Orbirq

[![Website](https://img.shields.io/badge/Website-FF7139?style=for-the-badge&logo=Firefox-Browser&logoColor=white)](https://orbirq.com)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/regyfelipe/orbirq)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/OrbirqApp)

---

### Desenvolvido com ❤️ por Regy Robson

[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/llippe.r/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/fepink/)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://wa.me/55992801698)
