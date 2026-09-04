import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/home/data/courts_services.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';

class CourtsRepository {
  final CourtsServices courtServices = locator.get<CourtsServices>();

  Future<List<Club>> getAllCourts() async {
    try {
      final response = await courtServices.getAllCourts();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> courtsJson = data['clubs'] as List<dynamic>? ?? [];

      return courtsJson
          .map((json) => Club.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
