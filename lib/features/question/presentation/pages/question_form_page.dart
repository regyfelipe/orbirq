import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/presentation/bloc/question_form_bloc.dart';

class QuestionFormPage extends StatefulWidget {
  const QuestionFormPage({Key? key}) : super(key: key);

  @override
  _QuestionFormPageState createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _disciplineController = TextEditingController();
  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  final _yearController = TextEditingController();
  final _boardController = TextEditingController();
  final _examController = TextEditingController();
  final _textController = TextEditingController();
  final _supportingTextController = TextEditingController();
  final _explanationController = TextEditingController();
  
  final List<TextEditingController> _optionControllers = [];
  final List<String> _optionLetters = ['A', 'B', 'C', 'D', 'E'];
  String _correctAnswer = 'A';
  String _type = 'withText';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _disciplineController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _yearController.dispose();
    _boardController.dispose();
    _examController.dispose();
    _textController.dispose();
    _supportingTextController.dispose();
    _explanationController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Questão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: BlocConsumer<QuestionFormBloc, QuestionFormState>(
        listener: (context, state) {
          if (state is QuestionFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Questão salva com sucesso!')),
            );
            Navigator.of(context).pop();
          } else if (state is QuestionFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Informações Básicas'),
                  _buildTextField(controller: _disciplineController, label: 'Disciplina', hint: 'Ex: Direito'),
                  _buildTextField(controller: _subjectController, label: 'Matéria', hint: 'Ex: Direito Constitucional'),
                  _buildTextField(controller: _topicController, label: 'Tópico', hint: 'Ex: Poder Executivo'),
                  _buildTextField(controller: _yearController, label: 'Ano', hint: '2025', keyboardType: TextInputType.number),
                  _buildTextField(controller: _boardController, label: 'Banca', hint: 'Ex: CESPE, FGV, etc.'),
                  _buildTextField(controller: _examController, label: 'Concurso', hint: 'Ex: PF, PRF, etc.'),
                  
                  _buildSectionTitle('Conteúdo da Questão'),
                  _buildTextField(controller: _textController, label: 'Enunciado', hint: 'Digite o enunciado da questão', maxLines: 3),
                  _buildTextField(controller: _supportingTextController, label: 'Texto de Apoio (opcional)', hint: 'Digite o texto de apoio', maxLines: 3),
                  
                  _buildSectionTitle('Alternativas'),
                  ...List.generate(5, (index) => _buildOptionField(index)),
                  
                  _buildSectionTitle('Resposta Correta'),
                  DropdownButtonFormField<String>(
                    value: _correctAnswer,
                    items: _optionLetters.map((letter) {
                      return DropdownMenuItem(
                        value: letter,
                        child: Text('Alternativa $letter'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _correctAnswer = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Selecione a alternativa correta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  _buildSectionTitle('Explicação'),
                  _buildTextField(
                    controller: _explanationController,
                    label: 'Explicação da resposta',
                    hint: 'Explique por que esta é a resposta correta',
                    maxLines: 3,
                  ),
                  
                  _buildSectionTitle('Tipo de Questão'),
                  DropdownButtonFormField<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'withText', child: Text('Com Texto')),
                      DropdownMenuItem(value: 'noText', child: Text('Sem Texto')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tipo de questão',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: state is QuestionFormLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar Questão'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildOptionField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(_optionLetters[index]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(
              controller: _optionControllers[index],
              label: 'Alternativa ${_optionLetters[index]}',
              hint: 'Digite o texto da alternativa',
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final options = <QuestionOption>[];
      for (int i = 0; i < _optionControllers.length; i++) {
        options.add(QuestionOption(
          letter: _optionLetters[i],
          text: _optionControllers[i].text,
        ));
      }

      final question = Question(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        discipline: _disciplineController.text,
        subject: _subjectController.text,
        topic: _topicController.text,
        year: int.tryParse(_yearController.text) ?? DateTime.now().year,
        board: _boardController.text,
        exam: _examController.text,
        text: _textController.text,
        supportingText: _supportingTextController.text,
        correctAnswer: _correctAnswer,
        explanation: _explanationController.text,
        type: _type,
        options: options,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<QuestionFormBloc>().add(QuestionFormSubmitted(question));
    }
  }
}
