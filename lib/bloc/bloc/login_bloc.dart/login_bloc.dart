import 'package:bloc/bloc.dart';

import '../../../services/auth_service.dart';
import '../../event/login_event/login_event.dart';
import '../../state/login_state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
    : _authService = authService,
      super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await _authService.login(event.email, event.password);
      if (response != null) {
        emit(LoginSuccess(userId: response['user']['id'].toString()));
      } else {
        emit(const LoginFailure(error: 'Invalid creddentials'));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
