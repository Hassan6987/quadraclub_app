// lib/presentation/booking/data/booking_models.dart

enum MatchType { open, private }

enum BookingFormat { single, double_ }

enum BookingType { individual, match }

enum PaymentSplitOption { payAllReceiveLater, payAllNoSplit, payOnlyMyPart }

extension MatchTypeExtension on MatchType {
  String get label => this == MatchType.open ? 'Open' : 'Private';
  String get description => this == MatchType.open
      ? 'Any player can join'
      : 'Only invited player can join';
}

extension BookingFormatExtension on BookingFormat {
  String get label => this == BookingFormat.double_ ? 'Double' : 'Single';
}

extension PaymentSplitOptionExtension on PaymentSplitOption {
  String get title {
    switch (this) {
      case PaymentSplitOption.payAllReceiveLater:
        return 'Pay everything now and receive later';
      case PaymentSplitOption.payAllNoSplit:
        return 'Pay everything now without splitting later';
      case PaymentSplitOption.payOnlyMyPart:
        return 'Pay only my part now';
    }
  }

  String get description {
    switch (this) {
      case PaymentSplitOption.payAllReceiveLater:
        return 'Court is already booked now, and you receive other players parts automatically after the match.';
      case PaymentSplitOption.payAllNoSplit:
        return 'Invite players can join without paying anything.';
      case PaymentSplitOption.payOnlyMyPart:
        return 'Court is not booked yet. It will only be booked when everyone joins. Risk loosing booking';
    }
  }

  String get type {
    switch (this) {
      case PaymentSplitOption.payAllReceiveLater:
        return 'pay_all_receive_later';
      case PaymentSplitOption.payAllNoSplit:
        return 'pay_all_no_split';
      case PaymentSplitOption.payOnlyMyPart:
        return 'pay_my_part';
    }
  }
}

class InvitablePlayerModel {
  final String id;
  final String name;
  final String avatarUrl;

  const InvitablePlayerModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}

String formatPrice(double amount) => '\$${amount.toStringAsFixed(2)}';

/// Adds a duration to a "HH:mm" start time string, returning "HH:mm".
String addDurationToTime(String start, Duration duration) {
  final parts = start.split(':');
  final startMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
  final endMinutes = startMinutes + duration.inMinutes;
  final hour = (endMinutes ~/ 60) % 24;
  final minute = endMinutes % 60;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
