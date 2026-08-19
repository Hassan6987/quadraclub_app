part of 'auth_bloc.dart';

enum AuthStateStatus {
  initial,
  authenticating,
  loading,
  updating,
  success,
  unVerified,
  verified,
  otpSent,
  failure,
  unAuthenticated,
  deleting,
  onboarding,
}

class AuthState extends Equatable {
  final AuthStateStatus status;
  final String? error;
  final UserModel? user;

  const AuthState({
    this.status = AuthStateStatus.initial,
    this.error,
    this.user,
  });

  @override
  List<Object?> get props => [status, error, user];

  AuthState copyWith({
    AuthStateStatus? status,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
