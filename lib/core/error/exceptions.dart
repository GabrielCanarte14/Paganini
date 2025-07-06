class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Exception'});

  @override
  String toString() => message;
}

class NetworkException implements Exception {}

class CacheException implements Exception {}

class GraphQLException implements ServerException {
  @override
  final String message;
  GraphQLException({required this.message});
}
