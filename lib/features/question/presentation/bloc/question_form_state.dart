part of 'question_form_bloc.dart';

@immutable
abstract class QuestionFormState extends Equatable {
  const QuestionFormState();

  @override
  List<Object> get props => [];
}

class QuestionFormInitial extends QuestionFormState {}

class QuestionFormLoading extends QuestionFormState {}

class QuestionFormSuccess extends QuestionFormState {
  final Question question;

  const QuestionFormSuccess(this.question);

  @override
  List<Object> get props => [question];
}

class QuestionFormError extends QuestionFormState {
  final String message;

  const QuestionFormError(this.message);

  @override
  List<Object> get props => [message];
}
