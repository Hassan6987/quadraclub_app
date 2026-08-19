import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_services.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';

class AuthProvider {
  final AuthServices authServices = AuthServices();
  final StorageService storageService = locator.get<StorageService>();

  Future<UserModel> getUserProfile() async {
    try {
      final response = await authServices.getUserProfile();
      final responseData = response.data;
      return UserModel.fromJson(responseData['user']);
    } catch (e) {
      rethrow;
    }
  }


  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await authServices.signIn(
        email: email,
        password: password,
      );
      final data = response.data;
      final token = data['token'];
      await storageService.saveToken(token);
      return UserModel.fromJson(data['user']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      await authServices.resendOTP(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount({required String id}) async {
    try {
      await authServices.deleteAccount(id: id);
      await storageService.removeToken();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({required SignupData data}) async {
    try {
      await authServices.signUp(data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyCode({required String email, required String code}) async {
    try {
      await authServices.verifyOTP(email: email, code: code);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> setupProfile({required SignupData myData}) async {
    try {
      final response = await authServices.createProfile(data: myData);
      final data = response.data;
      final token = data['token'];
      await storageService.saveToken(token);
      return UserModel.fromJson(data['user']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await authServices.forgetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      await authServices.resetPassword(
        email: email,
        otp: otp,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    String? college,
    File? image,
  }) async {
    try {
      // await authServices.updateProfile(
      //   name: name,
      //   college: college,
      //   profile: image,
      // );
    } catch (e) {
      rethrow;
    }
  }
}