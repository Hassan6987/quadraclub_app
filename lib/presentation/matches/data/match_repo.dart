import 'dart:developer';

import 'package:quadraclub_app/data/stripe-services.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/data/match_services.dart';

class MatchRepo {
  final MatchServices _services = locator.get<MatchServices>();

  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await _services.getAllBookings();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> bookingsJson =
          data['bookings'] as List<dynamic>? ?? [];
      return bookingsJson
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getPortfolioBalance() async {
    try {
      final response = await _services.getPortfolioBalance();
      final data = response.data as Map<String, dynamic>;
      return data['portfolioBalance'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinMatchBooking({
    required String id,
    String? message,
    required bool isPortfolio,
    String? name,
    String? number,
    String? cvc,
    String? expiry,
  }) async {
    try {
      if (isPortfolio) {
        await _services.joinMatchBooking(
            id: id, isPortfolio: isPortfolio, message: message);
      } else {
        // Example:
        // "08/28" -> ["08", "28"]
        final expiryParts = expiry!.split('/');
        if (expiryParts.length != 2) {
          throw Exception('Invalid card expiry date');
        }
        final expMonth = int.tryParse(expiryParts[0]);
        final expYearShort = int.tryParse(expiryParts[1]);
        if (expMonth == null || expYearShort == null) {
          throw Exception('Invalid card expiry date');
        }
        // Convert 28 -> 2028
        final expYear = 2000 + expYearShort;

        final paymentMethodId = await StripeServices.createPaymentMethod(
          cardNumber: number!,
          expMonth: expMonth,
          expYear: expYear,
          cvc: cvc!,
          cardholderName: name!,
        );

        if (paymentMethodId == null) {
          throw Exception('Failed to create Stripe PaymentMethod');
        }
        log('Payment Method ID: $paymentMethodId');
        await _services.joinMatchBooking(
            id: id,
            isPortfolio: isPortfolio,
            paymentId: paymentMethodId,
            cardHolderName: name,
            message: message
        );
      }
    } catch (e) {
      rethrow;
    }
  }


}
