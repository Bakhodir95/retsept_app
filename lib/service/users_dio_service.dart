// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:retsept_app/core/network/dio_client.dart';
import 'package:retsept_app/data/models/user_model.dart';

class UsersDioService {
  final _dio = DioClient();

  Future<UserModels?> getAuthenticatedUser() async {
    try {
      String? id = await _dio.getUserId();
      if (id == null) {
        return null;
      }

      final response = await _dio.get(
        url: "/users.json",
        queryParams: {
          'orderBy': '"id"',
          'equalTo': '"$id"',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? usersData =
            response.data as Map<String, dynamic>?;

        if (usersData != null && usersData.isNotEmpty) {
          final userKey =
              usersData.keys.first; // Get the key (e.g., -O4IYK3_Q7zvdzJkuG9y)
          final userData = usersData[userKey] as Map<String, dynamic>;
          // print("User Data: $userData");

          UserModels user = UserModels(
              userName: userData["userName"],
              imageUrl: userData["imageUrl"],
              id: userData["id"]);

          // // Extract and return the userName
          // final userName = userData['userName'] as String?;
          return user;
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to retrieve user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio service error: $e");
      rethrow;
    } catch (e) {
      print("Error during getAuthenticatedUser: $e");
      rethrow;
    }
  }

  Future<void> addUser(String userName, String imageUrl) async {
    try {
      String? id = await _dio.getUserId();
      UserModels user = UserModels(
        userName: userName,
        imageUrl: imageUrl,
        id: id !,
      );
      final response = await _dio.add(url: "/users.json", data: user.toMap());

      if (response.statusCode == 302) {
        final redirectUrl = response.headers.value('location');
        if (redirectUrl != null) {
          final redirectedResponse = await _dio.add(
            url: redirectUrl,
          );
          if (redirectedResponse.statusCode == 200) {
            UserModels.fromMap(redirectedResponse.data);
          } else {
            throw Exception('Redirected request failed.');
          }
        } else {
          throw Exception('Redirect URL not found.');
        }
      } else if (response.statusCode == 200) {
        UserModels.fromMap(response.data);
      } else {
        throw Exception('Failed to add retsept: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio service error: $e");
      rethrow;
    } catch (e) {
      print("Error during add: $e");
      rethrow;
    }
  }
}

void main(List<String> args) {
  UsersDioService usersDioService = UsersDioService();
  usersDioService.addUser("Feruza", "image.url");
}
