# Sistema de Simulados - Orbirq

## 📋 Visão Geral

O sistema de simulados do Orbirq foi desenvolvido seguindo os princípios do **Clean Architecture** e **Provider Pattern**, oferecendo uma solução robusta e escalável para gerenciamento de simulados de concursos públicos.

## 🏗️ Arquitetura

### Estrutura de Pastas

```
lib/features/simulados/
├── models/
│   └── simulado.dart              # Modelos de dados
├── services/
│   └── simulado_service.dart      # Lógica de negócio e dados
├── controllers/
│   └── simulado_controller.dart   # Gerenciamento de estado
├── screens/
│   ├── simulado_lista_screen.dart     # Lista de simulados
│   └── simulado_execucao_screen.dart  # Execução do simulado
├── widgets/
│   ├── simulado_card.dart             # Card de simulado
│   ├── simulado_filtros_widget.dart   # Filtros avançados
│   ├── simulado_timer_widget.dart     # Timer do simulado
│   ├── simulado_progress_widget.dart  # Progresso do simulado
│   └── simulado_questao_widget.dart   # Widget de questão
└── README.md
```

## 🎯 Funcionalidades

### 1. Lista de Simulados
- **Busca em tempo real** com debounce
- **Filtros avançados**:
  - Por disciplina
  - Por banca
  - Por ano
  - Por nível de dificuldade
  - Gratuitos/Pagos
  - Novos/Existentes
- **Pull to refresh**
- **Tratamento de erros**
- **Estados de loading**

### 2. Execução de Simulados
- **Timer configurável** com alertas visuais
- **Navegação entre questões**
- **Progresso em tempo real**
- **Pausar/Retomar**
- **Finalização automática**
- **Estatísticas detalhadas**

### 3. Gerenciamento de Estado
- **Provider Pattern** para estado global
- **Separação de responsabilidades**
- **Reatividade automática**
- **Gerenciamento de ciclo de vida**

## 🔧 Modelos de Dados

### Simulado
```dart
class Simulado {
  final String id;
  final String titulo;
  final String descricao;
  final int totalQuestoes;
  final int tempoMinutos;
  final bool isNovo;
  final SimuladoTipo tipo;
  final List<String> disciplinas;
  final String? banca;
  final int? ano;
  final String? nivelDificuldade;
  final bool isGratuito;
  final double? preco;
}
```

### SimuladoExecucao
```dart
class SimuladoExecucao {
  final String id;
  final String simuladoId;
  final String userId;
  final DateTime dataInicio;
  final int tempoTotal;
  final int tempoRestante;
  final SimuladoStatus status;
  final Map<int, String> respostas;
  final Map<int, bool> acertos;
  final double? pontuacaoFinal;
}
```

## 🚀 Como Usar

### 1. Inicializar Controller
```dart
ChangeNotifierProvider(
  create: (_) => SimuladoController(),
  child: SimuladosScreen(),
)
```

### 2. Consumir Estado
```dart
Consumer<SimuladoController>(
  builder: (context, controller, child) {
    return ListView.builder(
      itemCount: controller.simulados.length,
      itemBuilder: (context, index) {
        final simulado = controller.simulados[index];
        return SimuladoCard(simulado: simulado);
      },
    );
  },
)
```

### 3. Iniciar Simulado
```dart
final controller = context.read<SimuladoController>();
final sucesso = await controller.iniciarSimulado(simuladoId, userId);
```

## 📊 Estados do Simulado

- **naoIniciado**: Simulado criado mas não iniciado
- **emAndamento**: Simulado ativo com timer rodando
- **pausado**: Simulado pausado temporariamente
- **concluido**: Simulado finalizado com resultado
- **cancelado**: Simulado cancelado pelo usuário

## 🎨 Componentes UI

### SimuladoCard
- Exibe informações do simulado
- Indicador de simulado novo
- Informações de tempo e questões
- Botão de iniciar
- Indicador de preço/gratuito

### SimuladoFiltrosWidget
- Filtros expansíveis
- Seleção múltipla de disciplinas
- Dropdowns para banca, ano, dificuldade
- Checkboxes para opções
- Botões de aplicar/limpar

### SimuladoTimerWidget
- Timer visual com cores dinâmicas
- Alerta quando tempo está baixo
- Formato MM:SS

### SimuladoProgressWidget
- Barra de progresso
- Estatísticas de acertos/erros
- Contador de questões respondidas

## 🔄 Fluxo de Dados

1. **Carregamento**: Controller carrega simulados do service
2. **Filtros**: Usuário aplica filtros → Controller atualiza lista
3. **Início**: Usuário inicia simulado → Controller cria execução
4. **Execução**: Controller gerencia timer e respostas
5. **Finalização**: Controller calcula resultado e salva

## 🛠️ Extensibilidade

### Adicionar Novo Filtro
1. Adicionar propriedade no controller
2. Atualizar service com nova lógica
3. Adicionar UI no SimuladoFiltrosWidget

### Adicionar Novo Tipo de Simulado
1. Adicionar enum no modelo
2. Atualizar service com nova lógica
3. Adicionar UI específica se necessário

### Adicionar Nova Estatística
1. Adicionar getter no controller
2. Atualizar widgets de progresso
3. Adicionar persistência se necessário

## 🧪 Testes

### Testes Unitários
- Service: Lógica de negócio
- Controller: Gerenciamento de estado
- Modelos: Validações e métodos

### Testes de Widget
- Cards: Renderização e interações
- Filtros: Funcionalidade dos filtros
- Timer: Comportamento do timer

### Testes de Integração
- Fluxo completo de simulado
- Persistência de dados
- Navegação entre telas

## 📱 Responsividade

- **Mobile First**: Design otimizado para mobile
- **Adaptativo**: Funciona em tablets e desktop
- **Acessibilidade**: Suporte a leitores de tela
- **Performance**: Otimizado para dispositivos de baixo poder

## 🔒 Segurança

- **Validação de entrada**: Todos os dados são validados
- **Controle de acesso**: Verificação de permissões
- **Sanitização**: Dados limpos antes do processamento
- **Auditoria**: Log de ações importantes

## 🚀 Próximos Passos

1. **Persistência Local**: Salvar progresso offline
2. **Sincronização**: Sincronizar com backend
3. **Analytics**: Métricas de uso
4. **Notificações**: Lembretes de simulados
5. **Modo Offline**: Funcionalidade sem internet
6. **Compartilhamento**: Compartilhar resultados
7. **Ranking**: Comparação com outros usuários

## 📞 Suporte

Para dúvidas ou sugestões sobre o sistema de simulados, consulte a documentação ou entre em contato com a equipe de desenvolvimento. 