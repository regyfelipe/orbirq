class AppStrings {
  // Títulos
  static const String appTitle = 'Orbirq';
  static const String loginTitle = 'Login';
  static const String signUpTitle = 'Tela de Cadastro';
  static const String forgotPasswordTitle = 'Esqueceu a Senha';
  static const String questionsTitle = 'orbira';
  static const String homeTitle = 'orbira';

  // Labels
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Senha';
  static const String loginButton = 'Entrar';
  static const String fullNameLabel = 'nome completo';
  static const String confirmPasswordLabel = 'confirmação de senha';
  static const String accountTypeLabel = 'Tipo de Conta:';
  static const String studentLabel = 'Aluno';
  static const String teacherLabel = 'Professor';
  static const String signUpButton = 'Cadastra';
  static const String resetPasswordButton = 'Enviar Email';
  static const String backToLoginText = 'Voltar ao Login';

  // Home
  static const String ultimosAcessos = 'Ultimos acessos';
  static const String simuladosNovos = 'Simulados novos';
  static const String analiseDesempenho = 'Analise de desempenho';
  static const String verTodos = 'Ver todos';
  static const String iniciarSimulado = 'Iniciar Simulado';
  static const String verAnalise = 'Ver Análise';

  // Navigation Bar
  static const String navHome = 'Home';
  static const String navQuestoes = 'Questões';
  static const String navSimulados = 'Simulados';
  static const String navGrupos = 'Grupos';
  static const String navPerfil = 'Perfil';

  // Home Interactive Elements
  static const String seuProgresso = 'Seu Progresso';
  static const String acoesRapidas = 'Ações Rápidas';
  static const String desafioDoDia = 'Desafio do Dia';
  static const String sequenciaEstudos = 'Sequência de Estudos';
  static const String novaQuestao = 'Nova Questão';
  static const String meusFavoritos = 'Meus Favoritos';
  static const String historico = 'Histórico';
  static const String configuracoes = 'Configurações';
  static const String iniciarDesafio = 'Iniciar Desafio';
  static const String estudarAgora = 'Estudar Agora';
  static const String continuarAssim =
      'Continue assim! Você está no caminho certo.';
  static const String parabensEstudou = 'Parabéns! Você já estudou hoje!';
  static const String completeHoje = 'Complete hoje para manter sua sequência!';
  static const String concluido = '✓ Concluído';
  static const String recorde = 'RECORDE!';
  static const String diasSeguidos = 'dias seguidos';
  static const String recordeSequencia = 'recorde';
  static const String progresso = 'Progresso';
  static const String acertos = 'Acertos';
  static const String media = 'Média';
  static const String dias = 'Dias';

  // Questões
  static const String questionMetadata = 'Id_Questao Disciplina Assunto';
  static const String questionYear = 'Ano: 2005';
  static const String questionBoard = 'Banca: Cespe';
  static const String questionExam = 'Prova: PMCE';
  static const String optionA = 'A';
  static const String optionB = 'B';
  static const String optionC = 'C';
  static const String optionD = 'D';
  static const String optionE = 'E';

  // Mensagens
  static const String emailRequired = 'Por favor, insira seu email';
  static const String passwordRequired = 'Por favor, insira sua senha';
  static const String loginSuccess = 'Login realizado com sucesso!';
  static const String fullNameRequired = 'Por favor, insira seu nome completo';
  static const String confirmPasswordRequired = 'Por favor, confirme sua senha';
  static const String passwordsNotMatch = 'As senhas não coincidem';
  static const String accountTypeRequired =
      'Por favor, selecione um tipo de conta';
  static const String signUpSuccess = 'Cadastro realizado com sucesso!';
  static const String resetPasswordSuccess = 'Email de recuperação enviado!';
  static const String resetPasswordDescription =
      'Digite seu email para receber um link de recuperação de senha.';

  // Campos do cadastro - Aluno
  static const String cpfLabel = 'CPF (opcional)';
  static const String birthDateLabel = 'Data de nascimento (opcional)';
  static const String stateLabel = 'Estado (UF) (opcional)';
  static const String targetExamLabel = 'Objetivo/Concurso-alvo (opcional)';
  static const String inviteCodeLabel = 'Código de convite (opcional)';
  static const String profilePhotoLabel = 'Foto de perfil (opcional)';

  // Campos do cadastro - Professor
  static const String miniBioLabel = 'Mini bio';
  static const String miniBioHint = 'Conte um pouco sobre sua experiência...';
  static const String areaOfExpertiseLabel = 'Área de atuação';
  static const String areaOfExpertiseHint = 'Ex: Português, Penal, RLM...';
  static const String instagramOrWebsiteLabel = 'Instagram ou site (opcional)';
  static const String instagramOrWebsiteHint =
      'Link do Instagram ou site pessoal';
  static const String proofDocumentLabel = 'Comprovação (opcional)';
  static const String proofDocumentHint = 'Currículo ou certificado';
  static const String referralCodeLabel = 'Código de indicação (opcional)';
  static const String referralCodeHint = 'Código de outro professor';

  // Validações
  static const String passwordMinLength =
      'A senha deve ter pelo menos 6 caracteres';
  static const String invalidEmail = 'Email inválido';
  static const String invalidCpf = 'CPF inválido';
  static const String termsRequired =
      'Você deve aceitar os termos para continuar';
  static const String profilePhotoRequired =
      'Foto de perfil é obrigatória para professores';
  static const String miniBioRequired = 'Mini bio é obrigatória';
  static const String areaOfExpertiseRequired = 'Área de atuação é obrigatória';

  // Termos e LGPD
  static const String termsTitle = 'Termos de Uso e Política de Privacidade';
  static const String termsText =
      'Li e aceito os Termos de Uso e Política de Privacidade';
  static const String lgpdText =
      'Concordo com o tratamento dos meus dados pessoais conforme a LGPD';

  // Estados brasileiros
  static const List<String> brazilianStates = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  // Concursos/Objetivos
  static const List<String> targetExams = [
    'PF - Polícia Federal',
    'PRF - Polícia Rodoviária Federal',
    'PM - Polícia Militar',
    'PC - Polícia Civil',
    'INSS - Instituto Nacional do Seguro Social',
    'Receita Federal',
    'Tribunais',
    'Ministério Público',
    'Advocacia Pública',
    'Outro',
  ];

  // Áreas de atuação
  static const List<String> areasOfExpertise = [
    'Português',
    'Matemática',
    'Raciocínio Lógico',
    'Direito Constitucional',
    'Direito Administrativo',
    'Direito Penal',
    'Direito Civil',
    'Direito Processual',
    'Direito Tributário',
    'Direito do Trabalho',
    'Direito Previdenciário',
    'Informática',
    'Atualidades',
    'Outra',
  ];

  // Assets white
  static const String logo = 'assets/white/logo.png';
  static const String logoSplash = 'assets/white/logo-splash.png';
  static const String avatar = 'assets/white/avatar.png';


  // Novos elementos da tela de login
  static const String forgotPasswordText = 'esqueceu a senha?';
  static const String clickHere = 'Clique aqui';
  static const String orSeparator = 'Ou';
  static const String noAccountText = 'Não tem conta?';
  static const String googleLogin = 'Google';
  static const String facebookLogin = 'Facebook';




  static const String loginRoute = '/login';

}
