import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retsept_app/blocs/users_bloc/users_bloc.dart';
import 'package:retsept_app/blocs/users_bloc/users_event.dart';
import 'package:retsept_app/blocs/users_bloc/users_state.dart';
import 'package:retsept_app/data/models/user_model.dart';
import 'package:retsept_app/data/repositories/users_repository.dart';

// Mock class for UsersRepository
class MockUsersRepository extends Mock implements UsersRepository {}

// Test suite for UsersBloc  
void main() {
  late MockUsersRepository mockUsersRepository;
  late UsersBloc usersBloc;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usersBloc = UsersBloc(usersRepository: mockUsersRepository);
  });

  tearDown(() {
    usersBloc.close();
  });

  group('UsersBloc', () {
    // Test for AddUserEvent
    blocTest<UsersBloc, UsersState>(
      'emits [UsersLoading, UserAdded] when AddUserEvent is added and user is added successfully',
      build: () {
        when(() => mockUsersRepository.addUser(any(), any()))
            .thenAnswer((_) async {});
        return usersBloc;
      },
      act: (bloc) => bloc.add(AddUserEvent('Test User', 'http://image.url')),
      expect: () => [
        UsersLoading(),
        UserAdded(UserModels(userName: 'Test User', imageUrl: 'http://image.url', id: '')),
      ],
    );

    // Test for AddUserEvent with an error
    blocTest<UsersBloc, UsersState>(
      'emits [UsersLoading, UsersError] when AddUserEvent is added and repository throws an error',
      build: () {
        when(() => mockUsersRepository.addUser(any(), any()))
            .thenThrow(Exception('Failed to add user'));
        return usersBloc;
      },
      act: (bloc) => bloc.add(AddUserEvent('Test User', 'http://image.url')),
      expect: () => [
        UsersLoading(),
        UsersError('Exception: Failed to add user'),
      ],
    );

    // Test for GetAuthenticatedUserEvent
    blocTest<UsersBloc, UsersState>(
      'emits [UsersLoading, AuthenticatedUserLoaded] when GetAuthenticatedUserEvent is added and user is found',
      build: () {
        final user = UserModels(userName: 'Authenticated User', imageUrl: 'http://auth.image.url', id: '1');
        when(() => mockUsersRepository.getAuthenticatedUser())
            .thenAnswer((_) async => user);
        return usersBloc;
      },
      act: (bloc) => bloc.add(GetAuthenticatedUserEvent()),
      expect: () => [
        UsersLoading(),
        AuthenticatedUserLoaded(UserModels(userName: 'Authenticated User', imageUrl: 'http://auth.image.url', id: '1')),
      ],
    );

    // Test for GetAuthenticatedUserEvent when no user is found
    blocTest<UsersBloc, UsersState>(
      'emits [UsersLoading, UsersError] when GetAuthenticatedUserEvent is added and no user is found',
      build: () {
        when(() => mockUsersRepository.getAuthenticatedUser())
            .thenAnswer((_) async => null);
        return usersBloc;
      },
      act: (bloc) => bloc.add(GetAuthenticatedUserEvent()),
      expect: () => [
        UsersLoading(),
        UsersError('No authenticated user found'),
      ],
    );
  });
}
