import 'dart:developer';

import 'package:quadraclub_app/data/stripe-services.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/home/data/courts_services.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/individual_booking_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/match_booking_model.dart';

class CourtsRepository {
  final CourtsServices courtServices = locator.get<CourtsServices>();

  Future<List<Club>> getAllCourts() async {
    try {
      final response = await courtServices.getAllCourts();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> courtsJson = data['clubs'] as List<dynamic>? ?? [];

      return courtsJson
          .map((json) => Club.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookIndividual(IndividualBookingModel model) async {
    try {
      // Example:
      // "08/28" -> ["08", "28"]
      final expiryParts = model.cardExpiryDate.split('/');
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
        cardNumber: model.cardNo,
        expMonth: expMonth,
        expYear: expYear,
        cvc: model.cvc,
        cardholderName: model.cardHolderName,
      );

      if (paymentMethodId == null) {
        throw Exception('Failed to create Stripe PaymentMethod');
      }

      print('Payment Method ID: $paymentMethodId');

      await courtServices.bookIndividual(model, paymentMethodId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookMatch(MatchBookingModel model) async {
    try {
      // Example:
      // "08/28" -> ["08", "28"]
      final expiryParts = model.cardExpiryDate.split('/');
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
        cardNumber: model.cardNo,
        expMonth: expMonth,
        expYear: expYear,
        cvc: model.cvc,
        cardholderName: model.cardHolderName,
      );

      if (paymentMethodId == null) {
        throw Exception('Failed to create Stripe PaymentMethod');
      }

      log('Payment Method ID: $paymentMethodId');

      await courtServices.bookMatch(model, paymentMethodId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitePlayerModel>> getAllPlayers() async {
    try {
      final response = await courtServices.getAllPlayers();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> playersJson = data['players'] as List<dynamic>? ?? [];
      return playersJson
          .map((json) =>
          InvitePlayerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
