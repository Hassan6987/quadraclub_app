import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class AuthServices extends BaseApiProvider {
  Future<Response> getUserProfile() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/me',
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
        endpoint: '/api/auth/login/',
        data: {"email": email, "password": password},
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
        endpoint: '/api/auth/request-password-reset/',
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
        endpoint: '/api/auth/confirm-password-reset/',
        data: {
          "email": email,
          "otp": otp,
          "new_password": password,
          "confirm_password": password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteAccount({required int id}) async {
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

  Future<Response> requestOTP({required String email}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/request-signup/',
        data: {"email": email},
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
        endpoint: '/api/auth/verify-signup/',
        data: {"email": email, "code": code},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> setPassword({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/auth/complete-signup/',
        data: {"email": email, "password": password, "role": role},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createProfile({
    required String name,
    required String college,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "full_name": name,
        "graduation_year": "2001",
        "college_name": college,
        // "image": await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });
      final response = await request(
        method: HttpMethod.post,
        endpoint: "/api/profile/setup/",
        data: formData,
      );
      return response;
    } catch (e) {
      throw Exception("Failed to create profile: $e");
    }
  }

  Future<Response> addLink({required String link}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/profile/links/add/',
        data: {"url": link},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateLink({
    required String link,
    required String id,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.patch,
        endpoint: '/api/profile/links/$id/update/',
        data: {"url": link},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteLink({required String id}) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/profile/links/$id/delete/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getScannedAthletes() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/scans/mine/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserById(int id) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/users/$id/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addNote({
    required int id,
    required String note,
    required String type,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/users/$id/add-note/',
        data: {"note": note, "type": type},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateNote({
    required int id,
    required String note,
    required String type,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.patch,
        endpoint: '/api/notes/$id/update/',
        data: {"note": note, "type": type},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteNote({required int id}) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/notes/$id/delete/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> giveRating({required int id, required int rating}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/profile/rate/',
        data: {"user_id": id, "rating": rating},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAthleteNotes(int id) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/users/$id/notes/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAthleteRatings(int id) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/user/$id/ratings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> scanNFCTag({required String tagId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/profile/by-nfc/$tagId/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> scanQRCode({required String userId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/users/$userId/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateProfile({
    required String name,
    String? college,
    File? profile,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        "full_name": name,
        "graduation_year": "2001",
      };
      if (college != null) {
        formDataMap["college_name"] = college;
      }
      if (profile != null) {
        formDataMap["image"] = await MultipartFile.fromFile(
          profile.path,
          filename: profile.path.split('/').last,
        );
      }
      FormData formData = FormData.fromMap(formDataMap);
      final response = await request(
        method: HttpMethod.put,
        endpoint: "/api/profile/setup/",
        data: formData,
      );
      return response;
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  /// V2 functions for team roster management and team scanning

  Future<Response> getTeamRoster() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/coach/roster/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addPlayerToRoster({required int id}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/coach/roster/add/',
        data: {"athlete_id": "$id"},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> removePlayerFromRoster({required int id}) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/coach/roster/remove/$id/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> scanTeamNFCTag({required String tagId}) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/scan/team-nfc/',
        data: {"nfc_tag_id": tagId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> scanTeamQRCode({required String teamId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/teams/$teamId/qr-scan/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTeamRosterById({required String teamId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/teams/$teamId/roster/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEventsHistory({required int userId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/athletes/$userId/event-history/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEventsMetrics({
    required int userId,
    required String eventId,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/athletes/$userId/events/$eventId/metrics/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAthleteTimeline({required int userId}) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/athletes/$userId/timeline/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
