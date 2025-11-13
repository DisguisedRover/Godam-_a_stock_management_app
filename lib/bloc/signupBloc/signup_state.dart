import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String? userId;

  const SignupSuccess({this.userId});

  @override
  List<Object> get props => [userId ?? ''];
}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure({required this.error});

  @override
  List<Object> get props => [error];
}
