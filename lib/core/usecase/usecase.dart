import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Params<T> {
  final T value;
  
  Params(this.value);
}
