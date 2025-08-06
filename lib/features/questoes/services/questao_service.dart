import '../models/question.dart';
import '../../../core/constants/app_strings.dart';

class QuestaoService {
  // Simulação de dados - em um app real viria de uma API ou banco de dados
  static Question getSampleQuestion() {
    return _getAllQuestions().first;
  }

  static List<Question> getSampleQuestions() {
    return _getAllQuestions();
  }

  static List<Question> _getAllQuestions() {
    return [
      // Questão 1 - Direito Constitucional (COM TEXTO)
      Question(
        id: 1,
        discipline: 'Direito',
        subject: 'Direito Constitucional',
        year: 2005,
        board: 'Cespe',
        exam: 'PMCE',
        text:
            'A Lei nº 10.216/01, que diz respeito aos direitos e à proteção das pessoas acometidas de transtorno mental, determina que a internação',
        supportingText:
            'A Lei nº 10.216/01, conhecida como Lei da Reforma Psiquiátrica, estabelece diretrizes para a proteção e os direitos das pessoas portadoras de transtornos mentais e redireciona o modelo assistencial em saúde mental.',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text:
                'de pessoas com transtorno mental em instituições psiquiátricas só será realizada mediante laudo da equipe de saúde circunstanciado e justificado.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text:
                'voluntária em instituição psiquiátrica ocorrerá por solicitação da família acompanhada de laudo do médico psiquiatra.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text:
                'compulsória é estabelecida por laudo médico específico e indicação de um familiar responsável pelos cuidados dispensados ao usuário.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text:
                'voluntária se dá com consentimento do usuário que deve assinar um documento declarando que optou por essa medida.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text:
                'involuntária se dá quando é direcionada a instituições asilares solicitada pela família e assinada pelo usuário.',
          ),
        ],
        correctAnswer: 'A',
        explanation:
            'A Lei nº 10.216/01 estabelece que a internação de pessoas com transtorno mental em instituições psiquiátricas só será realizada mediante laudo da equipe de saúde circunstanciado e justificado, garantindo a proteção dos direitos fundamentais dos pacientes.',
        type: QuestionType.withText,
      ),

      // Questão 2 - Direito Penal (SIMPLES)
      Question(
        id: 2,
        discipline: 'Direito',
        subject: 'Direito Penal',
        year: 2018,
        board: 'FGV',
        exam: 'OAB',
        text: 'Em relação ao crime de furto, assinale a alternativa correta:',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text:
                'O furto qualificado pelo rompimento de obstáculo é sempre crime hediondo.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: 'O furto de coisa comum é crime impossível.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: 'O furto de uso é crime autônomo previsto no Código Penal.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: 'O furto mediante fraude é crime de natureza permanente.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text:
                'O furto de energia elétrica é crime específico previsto em lei especial.',
          ),
        ],
        correctAnswer: 'E',
        explanation:
            'O furto de energia elétrica é crime específico previsto no art. 155, §4º do Código Penal, sendo considerado crime autônomo e não mera modalidade do furto simples.',
        type: QuestionType.simple,
      ),

      // Questão 3 - Português (COM TEXTO)
      Question(
        id: 3,
        discipline: 'Português',
        subject: 'Gramática',
        year: 2020,
        board: 'Vunesp',
        exam: 'PM-SP',
        text:
            'Assinale a alternativa em que a palavra destacada está sendo empregada com o mesmo sentido que aparece em "O tempo passa rápido.":',
        supportingText:
            'A palavra "tempo" pode ter diferentes significados dependendo do contexto em que é utilizada. Pode se referir ao tempo cronológico, às condições meteorológicas, ou a um período específico.',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text: 'Ele tem tempo para tudo.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: 'O tempo está chuvoso.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: 'Chegou na hora certa.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: 'O tempo é relativo.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text: 'Perdeu muito tempo.',
          ),
        ],
        correctAnswer: 'B',
        explanation:
            'Em "O tempo está chuvoso", a palavra "tempo" refere-se às condições meteorológicas, assim como em "O tempo passa rápido" refere-se à passagem do tempo cronológico.',
        type: QuestionType.withText,
      ),

      // Questão 4 - Matemática (SIMPLES)
      Question(
        id: 4,
        discipline: 'Matemática',
        subject: 'Álgebra',
        year: 2019,
        board: 'Cesgranrio',
        exam: 'Petrobras',
        text: 'Se x + y = 10 e xy = 24, então o valor de x² + y² é:',
        options: [
          QuestionOption(letter: AppStrings.optionA, text: '52'),
          QuestionOption(letter: AppStrings.optionB, text: '76'),
          QuestionOption(letter: AppStrings.optionC, text: '100'),
          QuestionOption(letter: AppStrings.optionD, text: '124'),
          QuestionOption(letter: AppStrings.optionE, text: '148'),
        ],
        correctAnswer: 'A',
        explanation:
            'Usando a identidade (x + y)² = x² + y² + 2xy, temos: 10² = x² + y² + 2(24). Logo, 100 = x² + y² + 48. Portanto, x² + y² = 100 - 48 = 52.',
        type: QuestionType.simple,
      ),

      // Questão 5 - Raciocínio Lógico (SIMPLES)
      Question(
        id: 5,
        discipline: 'Raciocínio Lógico',
        subject: 'Lógica de Argumentação',
        year: 2021,
        board: 'Cespe',
        exam: 'TCU',
        text:
            'Considere as seguintes proposições: P: "João é médico"; Q: "João é professor". A proposição "João é médico ou professor" pode ser representada por:',
        options: [
          QuestionOption(letter: AppStrings.optionA, text: 'P ∧ Q'),
          QuestionOption(letter: AppStrings.optionB, text: 'P ∨ Q'),
          QuestionOption(letter: AppStrings.optionC, text: 'P → Q'),
          QuestionOption(letter: AppStrings.optionD, text: 'P ↔ Q'),
          QuestionOption(letter: AppStrings.optionE, text: '¬P ∧ ¬Q'),
        ],
        correctAnswer: 'B',
        explanation:
            'A proposição "João é médico ou professor" é uma disjunção inclusiva, representada por P ∨ Q, onde ∨ é o conectivo lógico "ou".',
        type: QuestionType.simple,
      ),

      // Questão 6 - Direito Administrativo (COM TEXTO)
      Question(
        id: 6,
        discipline: 'Direito',
        subject: 'Direito Administrativo',
        year: 2017,
        board: 'FCC',
        exam: 'TRT',
        text:
            'Sobre os princípios da Administração Pública, é correto afirmar que:',
        supportingText:
            'Os princípios da Administração Pública estão previstos no art. 37 da Constituição Federal, sendo eles: legalidade, impessoalidade, moralidade, publicidade e eficiência. Estes princípios orientam toda a atividade administrativa.',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text: 'A moralidade administrativa é princípio implícito.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: 'A publicidade é princípio expresso na Constituição.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: 'A eficiência foi incluída pela EC 19/98.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: 'A impessoalidade é princípio implícito.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text: 'A legalidade é princípio implícito.',
          ),
        ],
        correctAnswer: 'C',
        explanation:
            'A eficiência foi incluída como princípio expresso da Administração Pública pela Emenda Constitucional nº 19/1998, que reformou a administração pública.',
        type: QuestionType.withText,
      ),

      // Questão 7 - Informática (COM IMAGEM)
      Question(
        id: 7,
        discipline: 'Informática',
        subject: 'Microsoft Office',
        year: 2022,
        board: 'Cespe',
        exam: 'BB',
        text:
            'No Microsoft Excel, a função que retorna o número de células não vazias em um intervalo é:',
        imageUrl:
            'https://support.microsoft.com/images/pt-br/5feb1ba8-a0fb-49d1-8188-dcf1ba878a42?format=avif&w=800',
        options: [
          QuestionOption(letter: AppStrings.optionA, text: 'COUNT()'),
          QuestionOption(letter: AppStrings.optionB, text: 'COUNTA()'),
          QuestionOption(letter: AppStrings.optionC, text: 'COUNTBLANK()'),
          QuestionOption(letter: AppStrings.optionD, text: 'COUNTIF()'),
          QuestionOption(letter: AppStrings.optionE, text: 'COUNTIFS()'),
        ],
        correctAnswer: 'B',
        explanation:
            'A função COUNTA() conta o número de células não vazias em um intervalo, incluindo células que contêm texto, números, valores lógicos e erros.',
        type: QuestionType.withImage,
      ),

      // Questão 8 - Atualidades (SIMPLES)
      Question(
        id: 8,
        discipline: 'Atualidades',
        subject: 'Política Internacional',
        year: 2023,
        board: 'Cespe',
        exam: 'Câmara dos Deputados',
        text: 'Em 2023, qual país foi admitido como membro da OTAN?',
        options: [
          QuestionOption(letter: AppStrings.optionA, text: 'Ucrânia'),
          QuestionOption(letter: AppStrings.optionB, text: 'Finlândia'),
          QuestionOption(letter: AppStrings.optionC, text: 'Suécia'),
          QuestionOption(letter: AppStrings.optionD, text: 'Turquia'),
          QuestionOption(letter: AppStrings.optionE, text: 'Polônia'),
        ],
        correctAnswer: 'B',
        explanation:
            'A Finlândia foi admitida como membro da OTAN em 2023, tornando-se o 31º membro da aliança militar.',
        type: QuestionType.simple,
      ),

      // Questão 9 - Direito Civil (COM TEXTO)
      Question(
        id: 9,
        discipline: 'Direito',
        subject: 'Direito Civil',
        year: 2016,
        board: 'FGV',
        exam: 'OAB',
        text: 'Sobre a responsabilidade civil, é correto afirmar que:',
        supportingText:
            'A responsabilidade civil pode ser subjetiva ou objetiva. A responsabilidade subjetiva exige a comprovação de culpa, enquanto a objetiva independe de culpa, baseando-se na teoria do risco.',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text: 'A responsabilidade objetiva independe de culpa.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: 'A responsabilidade subjetiva prescinde de culpa.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: 'A responsabilidade civil sempre decorre de ato ilícito.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: 'A responsabilidade civil não admite excludentes.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text: 'A responsabilidade civil é sempre solidária.',
          ),
        ],
        correctAnswer: 'A',
        explanation:
            'A responsabilidade objetiva independe de culpa, baseando-se na teoria do risco, onde o agente responde pelos danos causados independentemente de ter agido com culpa.',
        type: QuestionType.withText,
      ),

      // Questão 10 - História (COM IMAGEM)
      Question(
        id: 10,
        discipline: 'História',
        subject: 'História do Brasil',
        year: 2020,
        board: 'Vunesp',
        exam: 'PM-SP',
        text: 'A Proclamação da República no Brasil ocorreu em:',
        imageUrl:
            'https://via.placeholder.com/400x200/FF5722/FFFFFF?text=Proclamação+da+República',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text: '7 de setembro de 1822',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: '15 de novembro de 1889',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: '13 de maio de 1888',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: '9 de janeiro de 1824',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text: '21 de abril de 1792',
          ),
        ],
        correctAnswer: 'B',
        explanation:
            'A Proclamação da República no Brasil ocorreu em 15 de novembro de 1889, liderada pelo Marechal Deodoro da Fonseca, pondo fim ao período imperial.',
        type: QuestionType.withImage,
      ),

      // Questão 11 - Geografia (SIMPLES)
      Question(
        id: 11,
        discipline: 'Geografia',
        subject: 'Geografia Física',
        year: 2021,
        board: 'Cespe',
        exam: 'UnB',
        text: 'Qual é o maior oceano do mundo?',
        options: [
          QuestionOption(letter: AppStrings.optionA, text: 'Oceano Atlântico'),
          QuestionOption(letter: AppStrings.optionB, text: 'Oceano Pacífico'),
          QuestionOption(letter: AppStrings.optionC, text: 'Oceano Índico'),
          QuestionOption(letter: AppStrings.optionD, text: 'Oceano Ártico'),
          QuestionOption(letter: AppStrings.optionE, text: 'Oceano Antártico'),
        ],
        correctAnswer: 'B',
        explanation:
            'O Oceano Pacífico é o maior oceano do mundo, cobrindo aproximadamente um terço da superfície da Terra.',
        type: QuestionType.simple,
      ),

      // Questão 12 - Biologia (COM TEXTO)
      Question(
        id: 12,
        discipline: 'Biologia',
        subject: 'Genética',
        year: 2022,
        board: 'Vunesp',
        exam: 'UNESP',
        text: 'Sobre a herança genética, é correto afirmar que:',
        supportingText:
            'A herança genética é o processo pelo qual as características são passadas dos pais para os filhos através dos genes. Os genes são segmentos de DNA que contêm as instruções para a síntese de proteínas.',
        options: [
          QuestionOption(
            letter: AppStrings.optionA,
            text: 'Todos os genes são dominantes.',
          ),
          QuestionOption(
            letter: AppStrings.optionB,
            text: 'Os genes estão localizados no citoplasma.',
          ),
          QuestionOption(
            letter: AppStrings.optionC,
            text: 'Os genes são segmentos de DNA.',
          ),
          QuestionOption(
            letter: AppStrings.optionD,
            text: 'A herança não é influenciada pelo ambiente.',
          ),
          QuestionOption(
            letter: AppStrings.optionE,
            text: 'Todos os caracteres são determinados por um único gene.',
          ),
        ],
        correctAnswer: 'C',
        explanation:
            'Os genes são segmentos de DNA que contêm as instruções para a síntese de proteínas e determinam as características hereditárias.',
        type: QuestionType.withText,
      ),
    ];
  }

  // Métodos futuros para integração com API
  static Future<List<Question>> fetchQuestions() async {
    // Simulação de chamada de API
    await Future.delayed(const Duration(milliseconds: 500));
    return _getAllQuestions();
  }

  static Future<Question?> fetchQuestionById(int id) async {
    // Simulação de chamada de API
    await Future.delayed(const Duration(milliseconds: 300));
    final questions = _getAllQuestions();
    try {
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para buscar questões por disciplina
  static List<Question> getQuestionsByDiscipline(String discipline) {
    return _getAllQuestions().where((q) => q.discipline == discipline).toList();
  }

  // Método para buscar questões por assunto
  static List<Question> getQuestionsBySubject(String subject) {
    return _getAllQuestions().where((q) => q.subject == subject).toList();
  }

  // Método para buscar questões por banca
  static List<Question> getQuestionsByBoard(String board) {
    return _getAllQuestions().where((q) => q.board == board).toList();
  }

  // Método para buscar questões por tipo
  static List<Question> getQuestionsByType(QuestionType type) {
    return _getAllQuestions().where((q) => q.type == type).toList();
  }
}
