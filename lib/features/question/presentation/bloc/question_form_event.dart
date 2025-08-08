part of 'question_form_bloc.dart';

@immutable
abstract class QuestionFormEvent extends Equatable {
  const QuestionFormEvent();

  @override
  List<Object> get props => [];
}

class QuestionFormSubmitted extends QuestionFormEvent {
  final Question question;

  const QuestionFormSubmitted(this.question);

  @override
  List<Object> get props => [question];
}
