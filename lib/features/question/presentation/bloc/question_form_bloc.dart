import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:orbirq/core/error/failures.dart';
import 'package:orbirq/features/question/domain/entities/question.dart';
import 'package:orbirq/features/question/domain/usecases/create_question.dart';

part 'question_form_event.dart';
part 'question_form_state.dart';

class QuestionFormBloc extends Bloc<QuestionFormEvent, QuestionFormState> {
  final CreateQuestion createQuestion;

  QuestionFormBloc({required this.createQuestion}) : super(QuestionFormInitial()) {
    on<QuestionFormSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    QuestionFormSubmitted event,
    Emitter<QuestionFormState> emit,
  ) async {
    emit(QuestionFormLoading());
    final result = await createQuestion(event.question);
    result.fold(
      (failure) => emit(QuestionFormError(_mapFailureToMessage(failure))),
      (question) => emit(QuestionFormSuccess(question)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Erro ao conectar ao servidor. Por favor, tente novamente mais tarde.';
    } else if (failure is NetworkFailure) {
      return 'Sem conexão com a internet. Por favor, verifique sua conexão.';
    } else if (failure is ValidationFailure) {
      return 'Dados inválidos. Por favor, verifique os campos informados.';
    } else {
      return 'Ocorreu um erro inesperado. Por favor, tente novamente.';
    }
  }
}
