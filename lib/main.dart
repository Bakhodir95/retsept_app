import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retsept_app/blocs/accounts_setup_bloc/accounts_setup_bloc.dart';
import 'package:retsept_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:retsept_app/blocs/category_bloc/category_bloc.dart';
import 'package:retsept_app/blocs/retsept_bloc/retsept_bloc.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_bloc.dart';
import 'package:retsept_app/blocs/users_bloc/users_bloc.dart';
import 'package:retsept_app/data/repositories/retsept_repository.dart';
import 'package:retsept_app/data/repositories/users_repository.dart';
import 'package:retsept_app/firebase_options.dart';
import 'package:retsept_app/data/repositories/category_repository.dart';
import 'package:retsept_app/service/category_services.dart';
import 'package:retsept_app/service/get_it.dart';
import 'package:retsept_app/service/photo_upload_storage_service.dart';
import 'package:retsept_app/service/retsept_dio_service.dart';
import 'package:retsept_app/service/users_dio_service.dart';
import 'package:retsept_app/ui/screens/splash_screen/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUp();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return UsersRepository(usersDioService: UsersDioService());
          },
        ),
        RepositoryProvider<RetseptRepository>(
          create: (context) => RetseptRepository(
            retseptService: RetseptService(),
          ),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(
            dioCategoriesServices: DioCategoriesServices(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UsersBloc(
              usersRepository: context.read<UsersRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => getIt.get<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => AccountSetupBloc(
              imagePicker: ImagePicker(),
              photoCloudStorageService: PhotoCloudStorageService(),
            ),
          ),
          BlocProvider(
            create: (context) {
              return RetseptBloc(
                retseptRepository: context.read<RetseptRepository>(),
              );
            },
          ),
          BlocProvider(
            create: (context) {
              return UserRetseptBloc(
                retseptRepository: context.read<RetseptRepository>(),
              );
            },
          ),
          BlocProvider(
            create: (context) {
              return CategoryBloc(
                categoryRepository: context.read<CategoryRepository>(),
              );
            },
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    ),
  );
}
