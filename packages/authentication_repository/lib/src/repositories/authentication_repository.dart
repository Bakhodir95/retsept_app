import 'package:authentication_repository/src/models/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_dio_service.dart';

class AuthRepository {
  final AuthDioService _authDioService;

  AuthRepository({
    required AuthDioService authDioService,
  }) : _authDioService = authDioService;

  Future<User> login(String email, String password) async {
    return await _authDioService.login(email, password);
  }

  Future<User> register(String email, String password) async {
    return await _authDioService.register(email, password);
  }

  Future<User?> checkTokenExpiry() async {
    return await _authDioService.checkTokenExpiry();
  }

  Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userData');
  }

  Future<User> signInWithGoogle() async {
    return await _authDioService.signInWithGoogle();
  }

  Future<void> forgotPassword(String email) async {
    return await _authDioService.forgotPassword(email);
  }
}
