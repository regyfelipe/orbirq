# Módulo de Questões

Este módulo implementa a funcionalidade de questões do aplicativo Orbirq, seguindo uma arquitetura modular e organizada.

## Estrutura de Pastas

```
lib/features/questoes/
├── controllers/          # Controladores de estado
│   └── questao_controller.dart
├── models/              # Modelos de dados
│   └── question.dart
├── services/            # Serviços de dados
│   └── questao_service.dart
├── widgets/             # Widgets específicos do módulo
│   ├── questao_header_widget.dart
│   ├── questao_text_widget.dart
│   ├── questao_options_widget.dart
│   ├── questao_answer_widget.dart
│   ├── questao_navigation_widget.dart
│   └── question_option_widget.dart
├── screens/             # Telas do módulo
│   └── questao_screen.dart
├── questoes.dart        # Arquivo barrel para exports
└── README.md           # Esta documentação
```

## Componentes

### Controllers
- **QuestaoController**: Gerencia o estado da questão, incluindo seleção de opções, timer, bookmark e feedback.

### Models
- **Question**: Modelo principal da questão com todas as propriedades necessárias.
- **QuestionOption**: Modelo para as opções de resposta.

### Services
- **QuestaoService**: Responsável por fornecer dados das questões (simulação de API).

### Widgets
- **QuestaoHeaderWidget**: Exibe informações da questão (disciplina, assunto, ano, banca, prova).
- **QuestaoTextWidget**: Exibe o texto da questão, texto de apoio e imagens.
- **QuestaoSupportingTextWidget**: Exibe o texto de apoio das questões.
- **QuestaoImageWidget**: Exibe imagens das questões com tratamento de erro.
- **QuestaoOptionsWidget**: Lista as opções de resposta.
- **QuestaoAnswerWidget**: Exibe o resultado e explicação após responder.
- **QuestaoNavigationWidget**: Botões de navegação (anterior, lista, próxima).
- **QuestaoStatsWidget**: Exibe estatísticas de progresso (respondidas, acertos, erros, taxa de acerto).
- **QuestionOptionWidget**: Widget individual para cada opção de resposta.

### Screens
- **QuestaoScreen**: Tela principal que integra todos os componentes.

## Tipos de Questões

O módulo suporta três tipos diferentes de questões:

### 1. **Questões Simples** (`QuestionType.simple`)
- Apenas pergunta e alternativas
- Formato direto e objetivo
- Exemplo: Questões de matemática, raciocínio lógico

### 2. **Questões com Texto de Apoio** (`QuestionType.withText`)
- Pergunta + texto explicativo + alternativas
- Texto de apoio fornece contexto adicional
- Exemplo: Questões de direito, português

### 3. **Questões com Imagem** (`QuestionType.withImage`)
- Pergunta + imagem + alternativas
- Imagem ilustrativa ou informativa
- Exemplo: Questões de informática, história

## Uso

```dart
import 'package:orbirq/features/questoes/questoes.dart';

// Navegar para a tela de questão
Navigator.pushNamed(context, AppRoutes.questions);

// Filtrar por tipo de questão
controller.loadQuestionsByType(QuestionType.simple);
controller.loadQuestionsByType(QuestionType.withText);
controller.loadQuestionsByType(QuestionType.withImage);
```

## Benefícios da Nova Estrutura

1. **Separação de Responsabilidades**: Cada componente tem uma responsabilidade específica.
2. **Reutilização**: Widgets podem ser reutilizados em outras partes do app.
3. **Testabilidade**: Controller isolado facilita testes unitários.
4. **Manutenibilidade**: Código organizado e fácil de manter.
5. **Escalabilidade**: Estrutura preparada para crescimento do módulo.

## Funcionalidades Implementadas

✅ **Navegação entre questões** - Botões anterior/próximo funcionais
✅ **Múltiplas questões** - 12 questões de diferentes disciplinas
✅ **Diferentes tipos de questões** - Simples, com texto de apoio e com imagem
✅ **Estatísticas de progresso** - Acompanhamento de acertos e erros
✅ **Filtros por disciplina/assunto/banca/tipo** - Métodos para filtrar questões
✅ **Indicador de progresso** - Mostra questão atual e total
✅ **Tratamento de imagens** - Carregamento com loading e tratamento de erro

## Próximos Passos

- [ ] Adicionar persistência de dados
- [ ] Implementar sistema de pontuação
- [ ] Criar testes unitários
- [ ] Adicionar animações de transição
- [ ] Implementar modo simulado
- [ ] Adicionar mais questões 