import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';
import 'package:quadraclub_app/presentation/home/data/models/individual_booking_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/match_booking_model.dart';
import 'package:quadraclub_app/utils/app_utils.dart';

class CourtsServices extends BaseApiProvider {
  Future<Response> getAllCourts() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/clubs/slots',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> bookIndividual(IndividualBookingModel model,
      String paymentId) async {
    try {
      final response = await request(
          method: HttpMethod.post,
          endpoint: '/api/booking',
          data: {
            "clubId": model.clubId,
            "courtId": model.courtId,
            "bookingDate": AppUtils.getFormattedDateWithDashNullable(
                model.bookingDate),
            "startTime": model.startTime,
            "endTime": model.endTime,
            "bookingType": "Reserve Individual",
            "cardholderName": model.cardHolderName,
            "paymentMethodId": paymentId,
            "totalPrice": model.totalPrice,
            "serviceFee": model.serviceFee
          }
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> bookMatch(MatchBookingModel model, String paymentId) async {
    try {
      final response = await request(
          method: HttpMethod.post,
          endpoint: '/api/booking',
          data: {
            "clubId": model.clubId,
            "courtId": model.courtId,
            "bookingDate": AppUtils.getFormattedDateWithDashNullable(
                model.bookingDate),
            "startTime": model.startTime,
            "endTime": model.endTime,
            "bookingType": "Match",
            "matchType": model.matchType,
            "format": model.format,
            "paymentType": model.paymentType,
            "cardholderName": model.cardHolderName,
            "paymentMethodId": paymentId,
            "totalPrice": model.totalPrice,
            "serviceFee": model.serviceFee
          }
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
