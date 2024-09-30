import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(InitialAuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckTokenExpiryEvent>(_onCheckTokenExpiry);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<ForgotPassword>(_onForgotPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPassword event, Emitter<AuthState> emit) async {
    try {
      _authRepository.forgotPassword(event.email);
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.register(event.email, event.password);
      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await _authRepository.logout();
      emit(UnAuthenticatedAuthState());
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> _onCheckTokenExpiry(
      CheckTokenExpiryEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    final user = await _authRepository.checkTokenExpiry();
    if (user != null) {
      emit(AuthenticatedAuthState(user));
    } else {
      emit(UnAuthenticatedAuthState());
    }
  }

  Future<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }
}
