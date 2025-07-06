const String withoutConnection = 'Sin conexión a internet';

abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({super.errorMessage = 'Error del servidor'});
}

class CacheFailure extends Failure {
  CacheFailure({super.errorMessage = 'Cache error'});
}

class DioFailure extends Failure {
  DioFailure({required super.errorMessage});
}
