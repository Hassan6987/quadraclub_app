import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/data/match_services.dart';

class MatchRepo {
  final MatchServices _services = locator.get<MatchServices>();

  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await _services.getAllBookings();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> bookingsJson =
          data['bookings'] as List<dynamic>? ?? [];
      return bookingsJson
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
