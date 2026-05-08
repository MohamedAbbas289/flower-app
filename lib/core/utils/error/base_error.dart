import 'package:flower_app/core/utils/error/error_handler.dart';

abstract class BaseError {
  static String handleException(Object exception) {
    return ErrorHandler.handle(exception);
  }
}