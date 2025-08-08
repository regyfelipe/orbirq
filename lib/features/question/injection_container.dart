import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orbirq/core/services/api_service.dart';
import 'package:orbirq/features/question/data/datasources/question_remote_data_source.dart';
import 'package:orbirq/features/question/data/datasources/question_remote_data_source_impl.dart';
import 'package:orbirq/features/question/data/repositories/question_repository_impl.dart';
import 'package:orbirq/features/question/domain/repositories/question_repository.dart';
import 'package:orbirq/features/question/domain/usecases/create_question.dart';
import 'package:orbirq/features/question/domain/usecases/get_question.dart';
import 'package:orbirq/features/question/domain/usecases/get_questions.dart';
import 'package:orbirq/features/question/presentation/bloc/question_form_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }
  
  if (!sl.isRegistered<ApiService>()) {
    sl.registerLazySingleton<ApiService>(
      () => ApiService(prefs: sl()),
    );
  }

  if (!sl.isRegistered<QuestionRemoteDataSource>()) {
    sl.registerLazySingleton<QuestionRemoteDataSource>(
      () => QuestionRemoteDataSourceImpl(apiService: sl()),
    );
  }

  if (!sl.isRegistered<QuestionRepository>()) {
    sl.registerLazySingleton<QuestionRepository>(
      () => QuestionRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<CreateQuestion>()) {
    sl.registerLazySingleton(() => CreateQuestion(sl()));
  }
  if (!sl.isRegistered<GetQuestion>()) {
    sl.registerLazySingleton(() => GetQuestion(sl()));
  }
  if (!sl.isRegistered<GetQuestions>()) {
    sl.registerLazySingleton(() => GetQuestions(sl()));
  }

  if (!sl.isRegistered<QuestionFormBloc>()) {
    sl.registerFactory(
      () => QuestionFormBloc(createQuestion: sl()),
    );
  }
}
