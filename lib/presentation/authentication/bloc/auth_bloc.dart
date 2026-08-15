import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';

import '../../../di/locator.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _authenticationProvider = locator.get<AuthProvider>();
  final StorageService _storageServices = locator.get<StorageService>();

  AuthBloc() : super(AuthState()) {
    on<AuthStarted>(_handleAuthStarted);
    on<LoginEvent>(_handleLogin);
    on<DeleteAccountEvent>(_handleDeleteAccount);
    on<RequestCode>(_handleRequestCode);
    on<VerifyCode>(_handleVerifyCode);
    on<SetPassword>(_handleSetPassword);
    on<SetupProfile>(_handleCreateProfile);
    on<ForgotPassword>(_handleForgetPassword);
    on<ResetPassword>(_handleResetPassword);
    on<UpdateProfile>(_handleUpdateProfile);
    on<AddLink>(_handleAddLink);
    on<UpdateLink>(_handleUpdateLink);
    on<DeleteLink>(_handleDeleteLink);
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
          if (user.profile?.status == "banned") {
            await StorageService().removeToken();
            emit(
              state.copyWith(
                status: AuthStateStatus.failure,
                error: "Your account has been banned.",
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
      await _authenticationProvider.requestCode(email: event.email);
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

  Future<void> _handleSetPassword(
    SetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      await _authenticationProvider.setPassword(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      await _authenticationProvider.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStateStatus.success));
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
      await _authenticationProvider.setupProfile(
        name: event.name,
        college: event.college,
      );
      if (event.linkThree != null && event.linkThree!.isNotEmpty) {
        await _authenticationProvider.addLink(url: event.linkThree!);
      }
      if (event.linkTwo != null && event.linkTwo!.isNotEmpty) {
        await _authenticationProvider.addLink(url: event.linkTwo!);
      }
      if (event.linkOne != null && event.linkOne!.isNotEmpty) {
        await _authenticationProvider.addLink(url: event.linkOne!);
      }
      final user = await _authenticationProvider.getUserProfile();
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
        college: event.college,
        image: event.profileImage,
      );
      await Future.delayed(Duration(seconds: 2));
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
      await _authenticationProvider.login(
        email: event.email,
        password: event.password,
      );
      final UserModel user = await _authenticationProvider.getUserProfile();
      if (user.profile?.status == "banned") {
        await StorageService().removeToken();
        emit(
          state.copyWith(
            status: AuthStateStatus.failure,
            error: "Your account has been banned.",
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

  Future<void> _handleAddLink(AddLink event, Emitter<AuthState> emit) async {
    try {
      await _authenticationProvider.addLink(url: event.url);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _handleUpdateLink(
    UpdateLink event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authenticationProvider.updateLink(
        url: event.url,
        id: "${event.id}",
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _handleDeleteLink(
    DeleteLink event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authenticationProvider.deleteLink(id: event.id.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
