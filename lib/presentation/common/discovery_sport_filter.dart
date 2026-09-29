import 'package:flutter/foundation.dart';
import 'package:quadraclub_app/utils/const/sports.dart';

/// Shared sport-chip selection for Courts, Classes and Matches.
///
/// Lives above the bottom nav so toggling a pill on one tab is still
/// selected when the user opens another.
class DiscoverySportFilter extends ChangeNotifier {
  final Set<String> _selected = {};
  bool _initialized = false;

  Set<String> get selected => _selected;

  void ensureInitialized(Iterable<String?> profileSports) {
    if (_initialized) return;
    _selected
      ..clear()
      ..addAll(defaultSelectedSportSlugs(profileSports));
    _initialized = true;
    notifyListeners();
  }

  void toggle(String sport) {
    if (!_initialized) {
      ensureInitialized(const []);
    }
    toggleSportSelection(_selected, sport);
    notifyListeners();
  }

  void replace(Set<String> sports) {
    _selected
      ..clear()
      ..addAll(sports.isEmpty ? kAllSportSlugs : sports);
    _initialized = true;
    notifyListeners();
  }
}
