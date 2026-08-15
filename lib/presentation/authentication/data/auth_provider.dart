import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_services.dart';
import 'package:quadraclub_app/presentation/home/data/athlete_model.dart';
import 'package:quadraclub_app/presentation/home/data/note_model.dart';
import 'package:quadraclub_app/presentation/home/data/rating_model.dart';
import 'package:quadraclub_app/presentation/home/data/scanned_team_model.dart';
import 'package:quadraclub_app/presentation/team_roster/data/team_roster_model.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_events.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_timeline.dart';

class AuthProvider {
  final AuthServices authServices = AuthServices();
  final StorageService storageService = locator.get<StorageService>();

  Future<UserModel> getUserProfile() async {
    try {
      final response = await authServices.getUserProfile();
      final responseData = response.data;
      final userData = UserModel.fromJson(responseData);
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await authServices.signIn(
        email: email,
        password: password,
      );
      final data = response.data;
      final role = data["role"];
      if (role != "COACH") {
        throw Exception("Invalid email or password");
      }
      final token = data['access'];
      final refresh = data['refresh'];
      await storageService.saveToken(token);
      await storageService.saveRefreshToken(refresh);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount({required int id}) async {
    try {
      await authServices.deleteAccount(id: id);
      await storageService.removeToken();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestCode({required String email}) async {
    try {
      await authServices.requestOTP(email: email);
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

  Future<void> setPassword({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await authServices.setPassword(
        email: email,
        password: password,
        role: role,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> setupProfile({
    required String name,
    required String college,
  }) async {
    try {
      final response = await authServices.createProfile(
        name: name,
        college: college,
      );
      final user = UserModel.fromMap(response.data);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addLink({required String url}) async {
    try {
      await authServices.addLink(link: url);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLink({required String url, required String id}) async {
    try {
      await authServices.updateLink(link: url, id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLink({required String id}) async {
    try {
      await authServices.deleteLink(id: id);
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
      await authServices.updateProfile(
        name: name,
        college: college,
        profile: image,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scanNFC({required String nfcId}) async {
    try {
      await authServices.scanNFCTag(tagId: nfcId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scanQRCode({required String userId}) async {
    try {
      await authServices.scanQRCode(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AthleteModel>> getScannedAthletes() async {
    try {
      final response = await authServices.getScannedAthletes();

      // IMPORTANT: response.data, not response.data()
      final List<dynamic> data = response.data as List<dynamic>;

      final athletes = data
          .map((json) => AthleteModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return athletes;
    } catch (e) {
      throw Exception("Failed to parse athletes: $e");
    }
  }

  Future<AthleteModel> getCurrentAthlete(int id) async {
    try {
      final response = await authServices.getUserById(id);
      final data = response.data as Map<String, dynamic>;
      final athlete = AthleteModel.fromJson(data);
      return athlete;
    } catch (e) {
      throw Exception("Failed to parse athlete: $e");
    }
  }

  Future<List<NoteModel>> getAthleteNotes(int id) async {
    try {
      final response = await authServices.getAthleteNotes(id);
      final List<dynamic> data = response.data as List<dynamic>;

      final notes = data
          .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return notes;
    } catch (e) {
      throw Exception("Failed to parse notes: $e");
    }
  }

  Future<void> giveRating({required int userId, required int rating}) async {
    try {
      await authServices.giveRating(id: userId, rating: rating);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNote({
    required int userId,
    required String note,
    required String type,
  }) async {
    try {
      await authServices.addNote(id: userId, note: note, type: type);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNote({
    required int noteId,
    required String note,
    required String type,
  }) async {
    try {
      await authServices.updateNote(id: noteId, note: note, type: type);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote({required int noteId}) async {
    try {
      await authServices.deleteNote(id: noteId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RatingModel>> getAthleteRatings(int id) async {
    try {
      final response = await authServices.getAthleteRatings(id);
      final List<dynamic> data = response.data as List<dynamic>;

      final ratings = data
          .map((json) => RatingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ratings;
    } catch (e) {
      throw Exception("Failed to parse ratings: $e");
    }
  }

  /// V2 Functionality Start here

  Future<List<TeamRoster>> getTeamRoster() async {
    try {
      final response = await authServices.getTeamRoster();
      final List<dynamic> data = response.data as List<dynamic>;

      final athletes = data
          .map((json) => TeamRoster.fromJson(json as Map<String, dynamic>))
          .toList();

      return athletes;
    } catch (e) {
      throw Exception("Failed to parse athletes: $e");
    }
  }

  Future<void> addPlayerToRoster({required int playerId}) async {
    try {
      await authServices.addPlayerToRoster(id: playerId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removePlayFromRoster({required int playerId}) async {
    try {
      await authServices.removePlayerFromRoster(id: playerId);
    } catch (e) {
      rethrow;
    }
  }

  Future<ScannedTeam> scanTeamNFC({required String nfcId}) async {
    try {
      // return dummyScannedTeam;
      final nfcResponse = await authServices.scanTeamNFCTag(tagId: nfcId);
      ScannedTeam scannedTeam = ScannedTeam.fromJson(nfcResponse.data);

      // Step 2: Fetch full team roster using the extracted team_id
      final rosterResponse = await authServices.getTeamRosterById(
        teamId: scannedTeam.teamId,
      );
      final List<dynamic> rosterData = rosterResponse.data as List<dynamic>;
      final List<ScannedTeamAthlete> teamAthletes = rosterData
          .map(
            (json) => ScannedTeamAthlete.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      // Step 3: Fetch coach's own roster to check inRoster status
      final coachRosterResponse = await authServices.getTeamRoster();
      final List<dynamic> coachRosterData =
          coachRosterResponse.data as List<dynamic>;

      // Build a Set of athlete IDs already in the coach's roster
      final Set<int> coachRosterIds = coachRosterData.map((json) {
        final athleteJson =
            (json as Map<String, dynamic>)['athlete'] as Map<String, dynamic>;
        return athleteJson['id'] as int;
      }).toSet();

      // Step 4: Mark each team athlete with inRoster true/false
      for (final athlete in teamAthletes) {
        athlete.inRoster = coachRosterIds.contains(athlete.id);
      }

      return scannedTeam.copyWith(athletes: teamAthletes);
    } catch (e) {
      rethrow;
    }
  }

  Future<ScannedTeam> scanTeamQR({required String teamId}) async {
    try {
      // Step 1: QR scan → get team info + team_id
      final qrResponse = await authServices.scanTeamQRCode(teamId: teamId);
      ScannedTeam scannedTeam = ScannedTeam.fromJson(qrResponse.data);

      // Step 2: Fetch full team roster using the extracted team_id
      final rosterResponse = await authServices.getTeamRosterById(
        teamId: scannedTeam.teamId,
      );
      final List<dynamic> rosterData = rosterResponse.data as List<dynamic>;
      final List<ScannedTeamAthlete> teamAthletes = rosterData
          .map(
            (json) => ScannedTeamAthlete.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      // Step 3: Fetch coach's own roster to check inRoster status
      final coachRosterResponse = await authServices.getTeamRoster();
      final List<dynamic> coachRosterData =
          coachRosterResponse.data as List<dynamic>;

      // Build a Set of athlete IDs already in the coach's roster
      final Set<int> coachRosterIds = coachRosterData.map((json) {
        final athleteJson =
            (json as Map<String, dynamic>)['athlete'] as Map<String, dynamic>;
        return athleteJson['id'] as int;
      }).toSet();

      // Step 4: Mark each team athlete with inRoster true/false
      for (final athlete in teamAthletes) {
        athlete.inRoster = coachRosterIds.contains(athlete.id);
      }

      return scannedTeam.copyWith(athletes: teamAthletes);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CompletedEvent>> getEventsHistory({required int userId}) async {
    try {
      // Step 1: Fetch event history
      final historyResponse = await authServices.getEventsHistory(
        userId: userId,
      );
      if (historyResponse.statusCode != 200 || historyResponse.data == null) {
        return [];
      }
      final List historyData = historyResponse.data is List
          ? historyResponse.data
          : (historyResponse.data['results'] ?? []);

      if (historyData.isEmpty) return [];

      // Step 2: For each history entry, extract the event and fetch its metrics concurrently
      final List<CompletedEvent?> results = await Future.wait(
        historyData.map<Future<CompletedEvent?>>((entry) async {
          try {
            // The event is nested inside each history entry
            final Map<String, dynamic> eventJson =
                entry['event'] as Map<String, dynamic>;
            final String eventId = eventJson['event_id'] as String;

            // Fetch metrics for this event
            final metricsResponse = await authServices.getEventsMetrics(
              userId: userId,
              eventId: eventId,
            );

            List<RecordedMetric> metrics = [];

            if (metricsResponse.statusCode == 200 &&
                metricsResponse.data != null) {
              final List metricsData = metricsResponse.data is List
                  ? metricsResponse.data
                  : (metricsResponse.data['results'] ?? []);

              metrics = metricsData
                  .map((m) => RecordedMetric.fromJson(m))
                  .toList();
            }

            return CompletedEvent.fromEventJson(eventJson, metrics);
          } catch (e) {
            debugPrint("Error processing event history entry: $e");
            return null;
          }
        }),
      );

      return results.whereType<CompletedEvent>().toList();
    } catch (e) {
      throw Exception("Failed to fetch event history: $e");
    }
  }

  Future<List<AthleteTimeline>> getTimelineMetrics(int userId) async {
    try {
      final response = await authServices.getAthleteTimeline(userId: userId);
      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data is List
            ? response.data
            : (response.data['results'] ?? []);

        return data
            .map((e) => AthleteTimeline.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception("Failed to fetch timeline: $e");
    }
  }
}

final ScannedTeam dummyScannedTeam = ScannedTeam(
  teamId: "d832e0df-c119-4d04-b57e-00cdab9390d6",
  name: "Iowa Lightning 16U",
  ageGroup: "16U",
  seasonYear: 2025,
  city: "Des Moines",
  athletes: [
    ScannedTeamAthlete(
      id: 9,
      fullName: "Hassan Raza",
      email: "HassanRazaLurkaJutt@gmail.com",
      image: "http://192.168.0.126:8000/media/profiles/9/scaled_1108.jpg",
      graduationYear: 2024,
      position: "RHP",
      inRoster: false,
    ),
    ScannedTeamAthlete(
      id: 1,
      fullName: "Muhammad Awais",
      email: "HassanRazaLurkaJutt@gmail.com",
      image: "http://192.168.0.126:8000/media/profiles/1/scaled_1000010005.jpg",
      graduationYear: 2020,
      position: "Pitcher",
      inRoster: true, // already in coach's roster
    ),
    ScannedTeamAthlete(
      id: 3,
      fullName: "John Doe",
      email: "HassanRazaLurkaJutt@gmail.com",
      image: null,
      // will show fallback icon
      graduationYear: 2025,
      position: "Pitcher",
      inRoster: false,
    ),
    ScannedTeamAthlete(
      id: 4,
      fullName: "James Carter",
      email: "HassanRazaLurkaJutt@gmail.com",
      image: null,
      graduationYear: 2019,
      position: "Shortstop",
      inRoster: false,
    ),
    ScannedTeamAthlete(
      id: 5,
      fullName: "William Brooks",
      email: "HassanRazaLurkaJutt@gmail.com",
      image: null,
      graduationYear: 2021,
      position: "First Baseman",
      inRoster: true,
    ),
  ],
);
