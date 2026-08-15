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

class RequestCode extends AuthEvent {
  final String email;

  const RequestCode({required this.email});
}

class VerifyCode extends AuthEvent {
  final String email;
  final String otp;

  const VerifyCode({required this.email, required this.otp});
}

class SetPassword extends AuthEvent {
  final String email;
  final String password;
  final String role;

  const SetPassword({
    required this.email,
    required this.password,
    required this.role,
  });
}

class SetupProfile extends AuthEvent {
  final String name;
  final String college;
  final String? linkOne;
  final String? linkTwo;
  final String? linkThree;

  const SetupProfile({
    required this.name,
    required this.college,
    this.linkOne,
    this.linkTwo,
    this.linkThree,
  });
}

class UpdateProfile extends AuthEvent {
  final String name;
  final String? college;
  final File? profileImage;

  const UpdateProfile({required this.name, this.college, this.profileImage});
}

class DeleteAccountEvent extends AuthEvent {
  final int id;

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

class AddLink extends AuthEvent {
  final String url;

  const AddLink({required this.url});
}

class UpdateLink extends AuthEvent {
  final int id;
  final String url;

  const UpdateLink({required this.id, required this.url});
}

class DeleteLink extends AuthEvent {
  final int id;

  const DeleteLink({required this.id});
}
