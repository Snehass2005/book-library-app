import 'dart:developer';
import 'dart:io';
import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/network/connection/connection_listener.dart';
import 'package:book_library_app/core/utils/configuration.dart';
import 'package:book_library_app/routes/app_router.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as response;
import 'package:get/get.dart' hide Response;
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';


mixin ExceptionHandlerMixin {
  final HiveService _hiveService = GetIt.instance<HiveService>();
  final UserPreferences userPreferences = UserPreferences.instance;

  Future<Either<AppException, response.Response>> handleException(
      Future<Response<dynamic>> Function() handler, {
        String endpoint = '',
      }) async {
    var connectionStatus = ConnectionStatusListener.getInstance();

    if (await connectionStatus.checkConnection()) {
      try {
        final res = await handler();
        return Right(response.Response(
          statusCode: res.statusCode ?? 200,
          data: res.data,
          statusMessage: res.statusMessage,
          requestOptions: res.requestOptions,
        ));
      } catch (e) {
        String message = '';
        String identifier = '';
        int statusCode = 0;

        if (e is DioException) {
          if (e.response?.statusCode == 401) {
            log("Unauthorized - Logging out...");
            logout();
            return Left(AppException(
              message: "SESSION_EXPIRED".tr,
              statusCode: 401,
              identifier: 'Unauthorized at $endpoint',
            ));
          }

          message = e.response?.data?['message'] ?? 'Internal error occurred';
          statusCode = e.response?.statusCode ?? 1;
          identifier = 'DioException ${e.message} at $endpoint';
        } else if (e is SocketException) {
          message = 'Unable to connect to server';
          statusCode = 0;
          identifier = 'SocketException ${e.message} at $endpoint';
        } else {
          message = 'Unknown error occurred';
          statusCode = 2;
          identifier = 'Unknown error ${e.toString()} at $endpoint';
        }

        return Left(AppException(
          message: message,
          statusCode: statusCode,
          identifier: identifier,
        ));
      }
    } else {
      log("No internet");
      return Left(AppException(
        message: "NO_INTERNET".tr,
        statusCode: 0,
        identifier: 'No Internet at $endpoint',
      ));
    }
  }

  void logout() async {
    await _hiveService.clear();
    userPreferences.clearPreferences();
    navigatorKey.currentState?.context.go(RoutesName.defaultPath);
  }
}
