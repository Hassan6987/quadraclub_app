import 'package:quadraclub_app/presentation/classes/data/classes_services.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '../../../di/locator.dart';

class ClassesRepo {
  final ClassesServices classesServices = locator.get<ClassesServices>();

  Future<List<Class>> getAllClasses() async {
    final response = await classesServices.getAllClasses();
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> classesJson = data['classes'] as List<dynamic>? ?? [];
    return classesJson
        .map((json) => Class.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
