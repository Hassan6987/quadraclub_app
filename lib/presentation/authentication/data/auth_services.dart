import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';

class AuthServices extends BaseApiProvider {
  Future<Response> getUserProfile() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/auth/me',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resendOTP({required String email}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/resend-otp',
        data: {"email": email},
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/login',
        data: {"email": email, "password": password, "role": "Player"},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> forgetPassword({required String email}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/forgot-password',
        data: {"email": email},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassword({
    required String password,
    required String email,
    required String otp,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/reset-password',
        data: {"email": email, "otp": otp, "newPassword": password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteAccount({required String id}) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/user/delete/$id/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signUp({required SignupData data}) async {
    try {
      FormData formData = FormData.fromMap({
        "fullName": data.fullName,
        "email": data.email,
        "password": data.password,
        "dateOfBirth": data.dateOfBirth,
        "role": "Player",
        "profilePhoto": await MultipartFile.fromFile(
          data.profilePhotoPath!,
          filename: data.profilePhotoPath!.split('/').last,
        ),
      });
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/register-step1',
        data: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyOTP({
    required String email,
    required String code,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/verify-register-otp',
        data: {"email": email, "otp": code},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createProfile({required SignupData data}) async {
    try {
      final sportsInfo = data.selectedSports.map((sport) {
        return {
          "sport": sport,
          "category": data.sportCategories[sport],
          "preferredSide": data.preferredSide,
        };
      }).toList();
      final response = await request(
        method: HttpMethod.put,
        endpoint: "/api/auth/complete-profile",
        data: {
          "email": data.email,
          "location": data.location,
          "gender": data.gender,
          "dominantHand": data.dominantHand,
          "sportsInfo": sportsInfo,
        },
      );
      return response;
    } catch (e) {
      throw Exception("Failed to create profile: $e");
    }
  }

  Future<Response> updateProfile({
    String? name,
    String? location,
    File? image,
    DateTime? dob,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "fullName": ?name,
        "dateOfBirth": ?dob,
        "location": ?location,
        if (image != null)
          "profilePhoto": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/update-profile',
        data: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
