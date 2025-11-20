import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth/auth_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService;

  SignupBloc({required AuthService authService})
    : _authService = authService,
      super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);

  }
  Future<void> _onSignupButtonPressed(
    SignupButtonPressed event,
    Emitter<SignupState> emit,
    
  ) async {
    emit(SignupLoading());
    try {
      final response = await _authService.signup(
        event.username,
        event.email,
        event.password,
        event.confirmPassword,
      );
      if (response != null) {
        emit(SignupSuccess(userId: response['user']['id'].toString()));
      } else {
        emit(const SignupFailure(error: 'Signup failed'));
      }
    } catch (e) {
      emit(SignupFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

}
