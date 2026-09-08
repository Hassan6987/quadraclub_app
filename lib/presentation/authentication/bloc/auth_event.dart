part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final SignupData data;

  const SignUpEvent({required this.data});
}

class RequestCode extends AuthEvent {
  final String email;

  const RequestCode({required this.email});
}

class VerifyCode extends AuthEvent {
  final String email;
  final String otp;

  const VerifyCode({required this.email, required this.otp});
}

class SetupProfile extends AuthEvent {
  final SignupData data;

  const SetupProfile({required this.data});
}

class UpdateProfile extends AuthEvent {
  final String name;
  final String? location;
  final File? profileImage;
  final DateTime? dob;


  const UpdateProfile(
      {required this.name, this.location, this.profileImage, this.dob});
}

class DeleteAccountEvent extends AuthEvent {
  final String id;

  const DeleteAccountEvent({required this.id});
}

class ForgotPassword extends AuthEvent {
  final String email;
  const ForgotPassword({required this.email});
}

class ResetPassword extends AuthEvent {
  final String email;
  final String otp;
  final String password;

  const ResetPassword({
    required this.email,
    required this.otp,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
