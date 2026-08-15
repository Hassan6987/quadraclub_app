import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/data/sport_model.dart';

class SportsData {
  static List<SportModel> availableSports = [
    SportModel(name: 'Padel', icon: Assets.svg.padelIcon.path),
    SportModel(name: 'Tennis', icon: Assets.svg.tennisIcon.path),
    SportModel(name: 'Beach Tennis', icon: Assets.svg.tennisIcon.path),
    SportModel(name: 'Pickleball', icon: Assets.svg.tennisIcon.path),
  ];
}
