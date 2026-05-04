import 'package:flower_app/core/utils/error/base_error.dart';

sealed class BaseResponse<T> {}

class SuccessBaseResponse<T> extends BaseResponse<T> {
  final T data;
  SuccessBaseResponse({required this.data});
}

class ErrorBaseResponse<T> extends BaseResponse<T> {
  final Exception exception;
  late final String errorMessage;

  ErrorBaseResponse({required this.exception}) {
    errorMessage = BaseError.handleException(exception);
  }
}
