import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:quadraclub_app/utils/const/sports.dart';

class DiscoverySportFilter extends ChangeNotifier {
  final Set<String> _selected = {};
  bool _initialized = false;
  bool _disposed = false;

  Set<String> get selected => _selected;

  void ensureInitialized(Iterable<String?> profileSports) {
    if (_initialized) return;
    _selected
      ..clear()
      ..addAll(defaultSelectedSportSlugs(profileSports));
    _initialized = true;
    _notifySafely();
  }

  void toggle(String sport) {
    if (!_initialized) {
      ensureInitialized(const []);
    }
    toggleSportSelection(_selected, sport);
    notifyListeners(); // called from a tap, not during build
  }

  void replace(Set<String> sports) {
    _selected
      ..clear()
      ..addAll(sports.isEmpty ? kAllSportSlugs : sports);
    _initialized = true;
    notifyListeners();
  }

  /// Notifies now if we're not building, otherwise right after the frame.
  void _notifySafely() {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}