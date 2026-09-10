import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_services.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_model.dart';

class AgendaRepo {
  final AgendaServices _services = locator.get<AgendaServices>();

  Future<List<AgendaItem>> getConfirmedAgenda() async {
    try {
      final response = await _services.getConfirmedAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AgendaItem>> getPendingAgenda() async {
    try {
      final response = await _services.getPastAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AgendaItem>> getPastAgenda() async {
    try {
      final response = await _services.getPastAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
