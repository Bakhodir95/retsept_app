import 'package:retsept_app/data/models/user_model.dart';
import 'package:retsept_app/service/users_dio_service.dart';

class UsersRepository{
  // ignore: unused_field
  final UsersDioService _usersDioService;
   UsersRepository({
    required UsersDioService usersDioService,
  }) : _usersDioService = usersDioService;

  Future<UserModels?> getAuthenticatedUser() async {
    return await _usersDioService.getAuthenticatedUser();
  }

  addUser(String userName, String imageUrl) {}

  
}