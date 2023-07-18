import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/datasources/auth_datasource_imp.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) =>
      datasource.checkAuthStatus(token);

  @override
  Future<User> login(String email, String password) =>
      datasource.login(email, password);

  @override
  Future<User> register(String email, String password, String fullname) =>
      datasource.register(email, password, fullname);
}
