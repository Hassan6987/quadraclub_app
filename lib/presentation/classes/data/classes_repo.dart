import 'dart:developer';

import 'package:quadraclub_app/data/stripe-services.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_services.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '../../../di/locator.dart';

class ClassesRepo {
  final ClassesServices classesServices = locator.get<ClassesServices>();

  Future<List<Class>> getAllClasses() async {
    try {
      final response = await classesServices.getAllClasses();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['classes'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => Class.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getPortfolioBalance() async {
    try {
      final response = await classesServices.getPortfolioBalance();
      final data = response.data as Map<String, dynamic>;
      return data['portfolioBalance'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> enrollInClass({
    required String id,
    required bool isPortfolio,
    String? name,
    String? number,
    String? cvc,
    String? expiry,
  }) async {
    try {
      if (isPortfolio) {
        await classesServices.enrollClass(id: id, isPortfolio: isPortfolio);
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
        await classesServices.enrollClass(
          id: id,
          isPortfolio: isPortfolio,
          paymentId: paymentMethodId,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
