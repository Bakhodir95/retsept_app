import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authentication_repository/src/models/user_models.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthDioService {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthDioService(this._dio, this._sharedPreferences);

  Future<User> _authenticate(
    String email,
    String password,
    String query,
  ) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:$query?key=AIzaSyBBcxJLr6uuuBW3jzY_BodYdPreiSYUA3c",
    );

    try {
      final response = await _dio.post(
        url.toString(),
        data: {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data);
        await _saveUserData(user);
        return user;
      } else {
        throw AuthException('Failed to authenticate: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final errorData = dioError.response?.data;
        throw AuthException(errorData['error']['message']);
      } else {
        throw AuthException(dioError.message!);
      }
    } catch (e) {
      throw AuthException('An unknown error occurred: $e');
    }
  }

  Future<User> register(String email, String password) async {
    return await _authenticate(email, password, "signUp");
  }

  Future<User> login(String email, String password) async {
    return await _authenticate(email, password, "signInWithPassword");
  }

  Future<User?> checkTokenExpiry() async {
    final userData = _sharedPreferences.getString("userData");
    if (userData == null) {
      return null;
    }

    final userMap = jsonDecode(userData);
    final expiryDate = DateTime.parse(userMap['expiresIn']);

    if (DateTime.now().isBefore(expiryDate)) {
      return User(
        id: userMap['localId'],
        email: userMap['email'],
        token: userMap['idToken'],
        refreshToken: userMap['refreshToken'],
        expiresIn: expiryDate,
      );
    } else {
      return null;
    }
  }

  Future<void> _saveUserData(User user) async {
    await _sharedPreferences.setString(
      'userData',
      jsonEncode(user.toJson()),
    );
  }

  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google sign-in aborted by user');
      }

      final googleAuth = await googleUser.authentication;

      final response = await _dio.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=AIzaSyBBcxJLr6uuuBW3jzY_BodYdPreiSYUA3c",
        data: {
          'postBody': 'id_token=${googleAuth.idToken}&providerId=google.com',
          'requestUri': 'http://localhost',
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data);
        await _saveUserData(user);
        return user;
      } else {
        throw AuthException(
            'Failed to authenticate with Google: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final errorData = dioError.response?.data;
        throw AuthException(errorData['error']['message']);
      } else {
        throw AuthException(dioError.message!);
      }
    } catch (e) {
      throw AuthException('An unknown error occurred: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyBBcxJLr6uuuBW3jzY_BodYdPreiSYUA3c",
    );

    try {
      final response = await _dio.post(
        url.toString(),
        data: {
          "requestType": "PASSWORD_RESET",
          "email": email,
        },
      );

      if (response.statusCode == 200) {
      } else {
        throw AuthException(
            'Failed to send reset email: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final errorData = dioError.response?.data;
        throw AuthException(errorData['error']['message']);
      } else {
        throw AuthException(dioError.message!);
      }
    } catch (e) {
      throw AuthException('An unknown error occurred: $e');
    }
  }
}
