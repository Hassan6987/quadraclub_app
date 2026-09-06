import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../app_exports.dart';

class StripeServices {
  StripeServices._();

  static final StripeServices instance = StripeServices._();

  static String apiKey = '${dotenv.env['STR_PUBLISH_KEY']}';
  static String baseUrl = 'https://api.stripe.com/v1';

  static Future<String> createStripeCustomer(name, email) async {
    log(" Name :: $name");
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'name': name, 'email': email},
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log(
          'Customer created successfully:  ${responseData['name']}, ${responseData['id']}',
        );
        return responseData['id'];
      } else {
        log('Failed to create customer. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return '';
      }
    } catch (e) {
      log('Error occurred: $e');
      return '';
    }
  }

  // UPDATED: Create payment with manual capture (hold funds)
  static Future<Map<String, dynamic>> makeConnectedPaymentWithHold(
    String amount,
    String restaurantId,
    String customerId,
  ) async {
    try {
      // Create payment intent with capture_method: manual
      Map<String, dynamic> paymentIntent = await createPaymentIntentWithHold(
        amount,
        'USD',
        restaurantId,
        customerId,
      );

      String paymentIntentId = paymentIntent['id'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'HomEatz',
          style: ThemeMode.light,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'USD',
            currencyCode: 'USD',
            testEnv: true,
          ),
          allowsDelayedPaymentMethods: true,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return {
        'paymentIntentId': paymentIntentId,
        'success': true,
        'status': 'requires_capture', // Payment is authorized but not captured
      };
    } catch (e) {
      debugPrint('Error making payment: $e');
      return {'error': e.toString(), 'success': false};
    }
  }

  // NEW: Create payment intent with manual capture
  static Future<Map<String, dynamic>> createPaymentIntentWithHold(
    String amount,
    String currency,
    String destination,
    String customerId,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'transfer_data[destination]': destination,
        'customer': customerId,
        'automatic_payment_methods[enabled]': 'true',
        'application_fee_amount': calculateTwentyPercent(amount),
        'capture_method': 'manual', // KEY: Hold the payment
      };

      var response = await http.post(
        Uri.parse('$baseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        log('Payment intent created (on hold): ${responseData['id']}');
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        log('Error in creating payment intent: $responseData');
        Flushbar(
          title:
              'Error in creating payment intent: ${responseData['error']['type']}',
          backgroundColor: kPrimaryColor,
          icon: const Icon(Icons.warning),
        );
        return json.decode(response.body);
      }
    } catch (err) {
      log('Error: ${err.toString()}');
      Flushbar(
        title: err.toString(),
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.warning),
      );
      throw Exception('Error: ${err.toString()}');
    }
  }

  // NEW: Capture payment when cook accepts order
  static Future<Map<String, dynamic>> capturePayment(
    String paymentIntentId,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/payment_intents/$paymentIntentId/capture'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log('Payment captured successfully: ${responseData['id']}');
        return {'success': true, 'data': responseData};
      } else {
        var responseData = jsonDecode(response.body);
        log('Failed to capture payment: ${responseData['error']['message']}');
        return {
          'success': false,
          'error':
              responseData['error']['message'] ?? 'Failed to capture payment',
        };
      }
    } catch (e) {
      log('Error capturing payment: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // NEW: Cancel payment when cook rejects order
  static Future<Map<String, dynamic>> cancelPayment(
    String paymentIntentId,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/payment_intents/$paymentIntentId/cancel'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log('Payment cancelled successfully: ${responseData['id']}');
        return {'success': true, 'data': responseData};
      } else {
        var responseData = jsonDecode(response.body);
        log('Failed to cancel payment: ${responseData['error']['message']}');
        return {
          'success': false,
          'error':
              responseData['error']['message'] ?? 'Failed to cancel payment',
        };
      }
    } catch (e) {
      log('Error cancelling payment: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Payment calculation helpers
  static String calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).round();
    return calculatedAmount.toString();
  }

  static String calculateTwentyPercent(String amount) {
    final percentageAmount = (20 / 100) * double.parse(amount);
    final calculatedAmount = (double.parse(percentageAmount.toString()) * 100)
        .round();
    log("total commission : ${calculatedAmount.toString()}");
    return calculatedAmount.toString();
  }

  // Keep other existing methods...
  static Future<Map<String, dynamic>> createConnectAccount({
    required String email,
    required String country,
    String? businessName,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/accounts'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'type': 'express',
          'country': country,
          'email': email,
          if (businessName != null) 'business_profile[name]': businessName,
          'capabilities[card_payments][requested]': 'true',
          'capabilities[transfers][requested]': 'true',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log('Connect account created successfully: ${responseData['id']}');
        return {
          'success': true,
          'accountId': responseData['id'],
          'data': responseData,
        };
      } else {
        log(
          'Failed to create connect account. Status code: ${response.statusCode}',
        );
        var responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error':
              responseData['error']['message'] ??
              'Failed to create connect account',
        };
      }
    } catch (e) {
      log('Error creating connect account: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createAccountLink({
    required String accountId,
    required String refreshUrl,
    required String returnUrl,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/account_links'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'account': accountId,
          'refresh_url': refreshUrl,
          'return_url': returnUrl,
          'type': 'account_onboarding',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return {
          'success': true,
          'url': responseData['url'],
          'expires_at': responseData['expires_at'],
        };
      } else {
        var responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error':
              responseData['error']['message'] ??
              'Failed to create account link',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getAccountStatus(String accountId) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/accounts/$accountId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'charges_enabled': responseData['charges_enabled'] ?? false,
          'details_submitted': responseData['details_submitted'] ?? false,
          'payouts_enabled': responseData['payouts_enabled'] ?? false,
        };
      } else {
        var responseData = jsonDecode(response.body);
        return {
          'success': false,
          'error':
              responseData['error']['message'] ??
              'Failed to get account status',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<String?> createPaymentMethod({
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
    required String cardholderName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment_methods'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'type': 'card',
          'card[number]': cardNumber.replaceAll(' ', ''),
          'card[exp_month]': expMonth.toString(),
          'card[exp_year]': expYear.toString(),
          'card[cvc]': cvc,
          'billing_details[name]': cardholderName,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final paymentMethodId = responseData['id'] as String;

        log('PaymentMethod created: $paymentMethodId');

        return paymentMethodId;
      }

      log(
        'Failed to create PaymentMethod: '
        '${responseData['error']?['message'] ?? response.body}',
      );

      return null;
    } catch (e) {
      log('Error creating PaymentMethod: $e');
      return null;
    }
  }
}
