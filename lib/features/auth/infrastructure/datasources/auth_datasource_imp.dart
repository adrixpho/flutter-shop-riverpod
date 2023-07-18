import 'package:dio/dio.dart';
import 'package:teslo_shop/config/const/environment.dart';
import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiURL));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(errorMessage: 'Token not valid.');
      }

      throw Exception();
    } catch (e) {
      throw CustomError(errorMessage: 'Unknown network error.');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      // if (e.type == DioExceptionType.connectionTimeout) {
      //   throw ConnectionTimeout();
      // }

      throw CustomError(
        errorMessage:
            e.response?.data['message'] ?? 'Shomething wrong happened.',
      );
    } catch (e) {
      throw CustomError(errorMessage: 'Unknown network error.');
    }
  }

  @override
  Future<User> register(String email, String password, String fullname) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullname,
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      throw CustomError(
        errorMessage:
            e.response?.data['message'] ?? 'Shomething wrong happened.',
      );
    } catch (e) {
      throw CustomError(errorMessage: 'Unknown network error.');
    }
  }
}
