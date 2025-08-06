// import 'package:flutter/material.dart';
// import 'package:orbirq/core/theme/Colors.dart';
// import '../../core/constants/app_strings.dart';
// import '../../models/question.dart';
// import '../../widgets/question_option_widget.dart';

// class QuestoesScreen extends StatefulWidget {
//   const QuestoesScreen({super.key});

//   @override
//   State<QuestoesScreen> createState() => _QuestoesScreenState();
// }

// class _QuestoesScreenState extends State<QuestoesScreen> {
//   late Question _currentQuestion;
//   int? _selectedOptionIndex;
//   bool _showAnswer = false;
//   bool _showExplanation = false;
//   bool _isBookmarked = false;
//   final int _totalTime = 300; // 5 minutos
//   int _timeRemaining = 300;
//   bool _timerActive = false;

//   final List<String> _mensagensMotivacionais = [
//     "Excelente! Continue assim que você vai longe! 🌟",
//     "Impressionante! Você está dominando o assunto! 🎯",
//     "Que orgulho! Seu esforço está valendo a pena! 🏆",
//     "Sensacional! Você está no caminho certo! ⭐",
//     "Incrível! Sua dedicação está dando resultados! 🌈",
//   ];

//   final List<String> _mensagensConstrutivas = [
//     "Não desanime! Erros são parte do aprendizado. 🌱",
//     "Continue tentando! Cada erro te deixa mais forte. 💪",
//     "Persista! O caminho do sucesso passa pela superação. 🎯",
//     "Mantenha o foco! Você está progredindo a cada tentativa. 🚀",
//     "Não desista! Você está mais perto do acerto. 💫",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadQuestion();
//   }

//   void _loadQuestion() {
//     // Dados da questão conforme a imagem
//     _currentQuestion = Question(
//       id: 1,
//       discipline: 'Direito',
//       subject: 'Direito Constitucional',
//       year: 2005,
//       board: 'Cespe',
//       exam: 'PMCE',
//       text:
//           'A Lei nº 10.216/01, que diz respeito aos direitos e à proteção das pessoas acometidas de transtorno mental, determina que a internação',
//       options: [
//         QuestionOption(
//           letter: AppStrings.optionA,
//           text:
//               'de pessoas com transtorno mental em instituições psiquiátricas só será realizada mediante laudo da equipe de saúde circunstanciado e justificado.',
//         ),
//         QuestionOption(
//           letter: AppStrings.optionB,
//           text:
//               'voluntária em instituição psiquiátrica ocorrerá por solicitação da família acompanhada de laudo do médico psiquiatra.',
//         ),
//         QuestionOption(
//           letter: AppStrings.optionC,
//           text:
//               'compulsória é estabelecida por laudo médico específico e indicação de um familiar responsável pelos cuidados dispensados ao usuário.',
//         ),
//         QuestionOption(
//           letter: AppStrings.optionD,
//           text:
//               'voluntária se dá com consentimento do usuário que deve assinar um documento declarando que optou por essa medida.',
//         ),
//         QuestionOption(
//           letter: AppStrings.optionE,
//           text:
//               'involuntária se dá quando é direcionada a instituições asilares solicitada pela família e assinada pelo usuário.',
//         ),
//       ],
//       correctAnswer: 'A', // Resposta correta
//     );
//   }

//   void _startTimer() {
//     setState(() {
//       _timerActive = true;
//       _timeRemaining = _totalTime;
//     });
//     Future.delayed(const Duration(seconds: 1), _updateTimer);
//   }

//   void _updateTimer() {
//     if (!_timerActive) return;

//     if (_timeRemaining > 0) {
//       setState(() {
//         _timeRemaining--;
//       });
//       Future.delayed(const Duration(seconds: 1), _updateTimer);
//     } else {
//       // Tempo esgotado - mostrar resposta automaticamente
//       setState(() {
//         _timerActive = false;
//         _showAnswer = true;
//       });
//       // Mostrar mensagem de tempo esgotado
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Tempo esgotado!'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   void _checkAnswer() {
//     if (_selectedOptionIndex == null) return;

//     setState(() {
//       _showAnswer = true;
//       _timerActive = false;
//     });
//   }

//   String _getMensagemAleatoria(bool acertou) {
//     final lista = acertou ? _mensagensMotivacionais : _mensagensConstrutivas;
//     final random = DateTime.now().millisecondsSinceEpoch % lista.length;
//     return lista[random];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryLight,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Row(
//           children: [
//             const Text(
//               'Questão 1',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             if (_timerActive)
//               Text(
//                 _formatTime(_timeRemaining),
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               )
//             else
//               TextButton.icon(
//                 onPressed: _startTimer,
//                 icon: const Icon(Icons.timer, color: Colors.white, size: 18),
//                 label: const Text(
//                   'Iniciar',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             IconButton(
//               icon: Icon(
//                 _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 setState(() => _isBookmarked = !_isBookmarked);
//               },
//             ),
//           ],
//         ),
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 20),
//               _buildQuestionText(),
//               const SizedBox(height: 20),
//               _buildOptions(),
//               if (_showAnswer) ...[
//                 const SizedBox(height: 20),
//                 _buildAnswerSection(),
//               ],
//               const SizedBox(height: 20),
//               _buildBottomButtons(),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: !_showAnswer && _selectedOptionIndex != null
//           ? FloatingActionButton.extended(
//               onPressed: _checkAnswer,
//               backgroundColor: AppColors.primaryLight,
//               label: const Text(
//                 'Resolver',
//                 style: TextStyle(color: Colors.white),
//               ),
//               icon: const Icon(Icons.check, color: Colors.white),
//             )
//           : null,
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Colors.grey[50]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),

//       child: Column(
//         children: [
//           IntrinsicHeight(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Text(
//                         'Disciplina: ',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           _currentQuestion.discipline,
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 VerticalDivider(
//                   color: Colors.grey[300],
//                   thickness: 1,
//                   width: 32,
//                 ),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Text(
//                         'Assunto: ',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           _currentQuestion.subject,
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.withOpacity(0.2)),
//             ),
//             child: Row(
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.calendar_today,
//                       size: 14,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Ano: ${_currentQuestion.year}',
//                       style: TextStyle(fontSize: 13, color: Colors.grey[800]),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   width: 1,
//                   height: 16,
//                   color: Colors.grey[300],
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.school_outlined,
//                       size: 14,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Banca: ${_currentQuestion.board}',
//                       style: TextStyle(fontSize: 13, color: Colors.grey[800]),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   width: 1,
//                   height: 16,
//                   color: Colors.grey[300],
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.business_outlined,
//                       size: 14,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Prova: ${_currentQuestion.exam}',
//                       style: TextStyle(fontSize: 13, color: Colors.grey[800]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionText() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         _currentQuestion.text,
//         style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
//       ),
//     );
//   }

//   Widget _buildOptions() {
//     return Column(
//       children: List.generate(_currentQuestion.options.length, (index) {
//         final option = _currentQuestion.options[index];
//         final optionLetter = option.letter;

//         bool? isCorrect;
//         if (_showAnswer) {
//           if (index == _selectedOptionIndex) {
//             // Opção selecionada pelo usuário
//             isCorrect = optionLetter == _currentQuestion.correctAnswer;
//           } else if (optionLetter == _currentQuestion.correctAnswer) {
//             // Opção correta (não selecionada pelo usuário)
//             isCorrect = true;
//           }
//         }

//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: QuestionOptionWidget(
//             option: option.copyWith(
//               isSelected: _selectedOptionIndex == index,
//               isCorrect: isCorrect,
//             ),
//             onTap: _showAnswer
//                 ? null
//                 : () {
//                     setState(() {
//                       if (_selectedOptionIndex == index) {
//                         _selectedOptionIndex = null;
//                       } else {
//                         _selectedOptionIndex = index;
//                       }
//                     });
//                   },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildAnswerSection() {
//     final letraSelecionada =
//         _currentQuestion.options[_selectedOptionIndex!].letter;
//     final respostaCorreta = letraSelecionada == _currentQuestion.correctAnswer;
//     final mensagem = _getMensagemAleatoria(respostaCorreta);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: respostaCorreta
//                 ? Colors.green.withOpacity(0.1)
//                 : Colors.orange.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: respostaCorreta ? Colors.green : Colors.orange,
//               width: 2,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     respostaCorreta ? Icons.celebration : Icons.psychology,
//                     color: respostaCorreta ? Colors.green : Colors.orange,
//                     size: 28,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       mensagem,
//                       style: TextStyle(
//                         color: respostaCorreta ? Colors.green : Colors.orange,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: respostaCorreta
//                         ? Colors.green.withOpacity(0.3)
//                         : Colors.orange.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       respostaCorreta ? Icons.check_circle : Icons.info,
//                       color: respostaCorreta ? Colors.green : Colors.orange,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Sua resposta: $letraSelecionada',
//                             style: TextStyle(
//                               color: respostaCorreta
//                                   ? Colors.green
//                                   : Colors.orange,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Resposta correta: ${_currentQuestion.correctAnswer}',
//                             style: const TextStyle(
//                               color: Colors.black87,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextButton(
//           onPressed: () {
//             setState(() {
//               _showExplanation = !_showExplanation;
//             });
//           },
//           style: TextButton.styleFrom(
//             backgroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(
//                 color: respostaCorreta
//                     ? Colors.green.withOpacity(0.3)
//                     : Colors.orange.withOpacity(0.3),
//               ),
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 _showExplanation ? Icons.remove : Icons.add,
//                 color: respostaCorreta ? Colors.green : Colors.orange,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Ver explicação',
//                 style: TextStyle(
//                   color: respostaCorreta ? Colors.green : Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (_showExplanation)
//           Container(
//             width: double.infinity,
//             margin: const EdgeInsets.only(top: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: respostaCorreta
//                     ? Colors.green.withOpacity(0.3)
//                     : Colors.orange.withOpacity(0.3),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Explicação',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'A Lei nº 10.216/01 estabelece que a internação de pessoas com transtorno mental em instituições psiquiátricas só será realizada mediante laudo da equipe de saúde circunstanciado e justificado, garantindo a proteção dos direitos fundamentais dos pacientes.',
//                   style: TextStyle(color: Colors.black87, height: 1.5),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildBottomButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         TextButton.icon(
//           onPressed: () {
//             // Navegar para questão anterior
//           },
//           icon: const Icon(Icons.arrow_back, color: AppColors.primaryLight),
//           label: const Text(
//             'Anterior',
//             style: TextStyle(color: AppColors.primaryLight),
//           ),
//         ),
//         TextButton.icon(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.list, color: AppColors.primaryLight),
//           label: const Text(
//             'Lista',
//             style: TextStyle(color: AppColors.primaryLight),
//           ),
//         ),
//         TextButton.icon(
//           onPressed: () {
//             // Navegar para próxima questão
//           },
//           icon: const Icon(Icons.arrow_forward, color: AppColors.primaryLight),
//           label: const Text(
//             'Próxima',
//             style: TextStyle(color: AppColors.primaryLight),
//           ),
//         ),
//       ],
//     );
//   }
// }
