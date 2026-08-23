
import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';

import '../../../di/locator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _authenticationProvider = locator.get<AuthProvider>();
  final StorageService _storageServices = locator.get<StorageService>();

  AuthBloc() : super(AuthState()) {
    on<AuthStarted>(_handleAuthStarted);
    on<SignUpEvent>(_handleSignUp);
    on<LoginEvent>(_handleLogin);
    on<DeleteAccountEvent>(_handleDeleteAccount);
    on<RequestCode>(_handleRequestCode);
    on<VerifyCode>(_handleVerifyCode);
    on<SetupProfile>(_handleCreateProfile);
    on<ForgotPassword>(_handleForgetPassword);
    on<ResetPassword>(_handleResetPassword);
    on<UpdateProfile>(_handleUpdateProfile);
  }

  Future<void> _handleAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.authenticating));
    try {
      final onBoarding = _storageServices.hasOnboarding();
      await Future.delayed(Duration(seconds: 2));
      if (onBoarding) {
        final token = _storageServices.hasToken();
        if (token) {
          final UserModel user = await _authenticationProvider.getUserProfile();
          if (user.isVerified == false) {
            await StorageService().removeToken();
            emit(
              state.copyWith(
                status: AuthStateStatus.unAuthenticated,
                error: "Your account is not verified.",
              ),
            );
            return;
          }
          emit(state.copyWith(status: AuthStateStatus.success, user: user));
        } else {
          emit(state.copyWith(status: AuthStateStatus.unAuthenticated));
        }
      } else {
        emit(state.copyWith(status: AuthStateStatus.onboarding));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStateStatus.unAuthenticated,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _handleSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.signUp(data: event.data);
      emit(state.copyWith(status: AuthStateStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleRequestCode(
    RequestCode event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.resendOtp(email: event.email);
      emit(state.copyWith(status: AuthStateStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleVerifyCode(
    VerifyCode event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.verifyCode(
        email: event.email,
        code: event.otp,
      );
      emit(state.copyWith(status: AuthStateStatus.verified));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleCreateProfile(
    SetupProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      final user = await _authenticationProvider.setupProfile(
          myData: event.data);
      emit(state.copyWith(status: AuthStateStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.updating));
    try {
      await _authenticationProvider.updateProfile(
        name: event.name,
          location: event.location,
        image: event.profileImage,
          dob: event.dob
      );
      final UserModel user = await _authenticationProvider.getUserProfile();
      emit(state.copyWith(status: AuthStateStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      final UserModel user = await _authenticationProvider.login(
        email: event.email,
        password: event.password,
      );
      if (user.isVerified == false) {
        await StorageService().removeToken();
        emit(
          state.copyWith(
            status: AuthStateStatus.unVerified,
            error: "Your account is Not Verified, We have sent an otp on your email please enter otp",
          ),
        );
        return;
      }
      emit(state.copyWith(status: AuthStateStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.deleting));
    try {
      await _authenticationProvider.deleteAccount(id: event.id);
      emit(state.copyWith(status: AuthStateStatus.unAuthenticated));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleForgetPassword(
    ForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.forgetPassword(email: event.email);
      emit(state.copyWith(status: AuthStateStatus.otpSent));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.resetPassword(
        email: event.email,
        otp: event.otp,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStateStatus.verified));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStateStatus.failure, error: e.toString()),
      );
    }
  }
}
