import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  // Dio-ni ro'yxatga olish
  getIt.registerSingleton(Dio());

  // SharedPreferences-ni asinxron ro'yxatga olish
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  // AuthDioService-ni ro'yxatga olish
  getIt.registerSingleton(
    AuthDioService(getIt.get<Dio>(), getIt.get<SharedPreferences>()),
  );

  // AuthRepository-ni ro'yxatga olish
  getIt.registerSingleton(
    AuthRepository(authDioService: getIt.get<AuthDioService>()),
  );

  // AuthBloc-ni ro'yxatga olish
  getIt.registerSingleton(
    AuthBloc(authRepository: getIt.get<AuthRepository>()),
  );

  ///registering imagePicker
  final ImagePicker imagePicker=ImagePicker();
  getIt.registerSingleton(imagePicker);


}
