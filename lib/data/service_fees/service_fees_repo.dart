import 'package:quadraclub_app/data/service_fees/service_fees_model.dart';
import 'package:quadraclub_app/data/service_fees/service_fees_services.dart';
import 'package:quadraclub_app/di/locator.dart';

class ServiceFeesRepo {
  final ServiceFeesServices _services = locator.get<ServiceFeesServices>();

  ServiceFees? _cache;

  Future<ServiceFees> getServiceFees({bool forceRefresh = false}) async {
    if (_cache != null && !forceRefresh) return _cache!;

    final response = await _services.getServiceFees();
    final data = response.data as Map<String, dynamic>;
    _cache = ServiceFees.fromJson(data);
    return _cache!;
  }

  void clearCache() => _cache = null;
}
