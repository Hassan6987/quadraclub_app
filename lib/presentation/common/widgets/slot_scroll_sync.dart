import 'package:flutter/widgets.dart';

/// Keeps every horizontal time-slot list on a screen at the same offset, so
/// dragging the slots of one club scrolls the slots of every other club too.
///
/// Owners create one group, hand it to each card, and dispose it. Cards ask
/// for a controller per row and release it when they are disposed — a card
/// scrolling off a `ListView` must not leave a dead controller behind.
class SlotScrollSync {
  final Set<ScrollController> _controllers = {};

  /// Offset the group is currently at, so rows created later (cards scrolled
  /// into view) attach already in sync.
  double _offset = 0;

  bool _isSyncing = false;

  bool _isDisposed = false;

  double get offset => _offset;

  ScrollController create() {
    final controller = ScrollController(initialScrollOffset: _offset);

    controller.addListener(() => _sync(controller));

    if (!_isDisposed) _controllers.add(controller);

    return controller;
  }

  void release(ScrollController controller) {
    // Once the group is gone its controllers are already disposed; a card
    // unmounting afterwards must not dispose them twice.
    if (_isDisposed) return;

    _controllers.remove(controller);

    controller.dispose();
  }

  void _sync(ScrollController source) {
    if (_isSyncing || !source.hasClients) return;

    _isSyncing = true;

    _offset = source.offset;

    for (final controller in _controllers) {
      if (controller == source || !controller.hasClients) continue;

      final target = _offset.clamp(0.0, controller.position.maxScrollExtent);

      if ((controller.offset - target).abs() > 0.5) {
        controller.jumpTo(target);
      }
    }

    _isSyncing = false;
  }

  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;

    for (final controller in _controllers) {
      controller.dispose();
    }

    _controllers.clear();
  }
}
