class MatchBookingModel {
  final String clubId;
  final String courtId;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final String matchType;
  final String format;
  final String paymentType;
  final String cardHolderName;
  final String cardNo;
  final String cvc;
  final String cardExpiryDate;
  final int totalPrice;
  final int serviceFee;

  MatchBookingModel({
    required this.clubId,
    required this.courtId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.matchType,
    required this.format,
    required this.paymentType,
    required this.cardHolderName,
    required this.cardNo,
    required this.cvc,
    required this.cardExpiryDate,
    required this.totalPrice,
    required this.serviceFee,
  });
}
