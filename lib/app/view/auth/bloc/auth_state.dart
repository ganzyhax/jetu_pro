part of 'auth_cubit.dart';

class AuthState {
  final String userId;
  final JetuUserModel userModel;
  final bool isLogged;
  final bool isLoading;
  final String error;
  final bool success;

  const AuthState({
    required this.userId,
    required this.userModel,
    required this.isLogged,
    required this.isLoading,
    required this.error,
    required this.success,
  });

  factory AuthState.initial() => AuthState(
        userId: '',
        userModel: JetuUserModel(),
        isLogged: false,
        isLoading: false,
        error: '',
        success: false,
      );

  AuthState copyWith({
    String? userId,
    JetuUserModel? userModel,
    bool? isLogged,
    bool? isLoading,
    String? error,
    bool? success,
  }) =>
      AuthState(
        userId: userId ?? this.userId,
        userModel: userModel ?? this.userModel,
        isLogged: isLogged ?? this.isLogged,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        success: success ?? this.success,
      );
}
