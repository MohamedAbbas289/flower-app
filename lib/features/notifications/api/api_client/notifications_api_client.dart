import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/notifications_response.dart';

part 'notifications_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class NotificationsApiClient {
  @factoryMethod
  factory NotificationsApiClient(Dio dio) => _NotificationsApiClient(dio);

  @GET(Endpoints.userNotifications)
  @Extra({ApiParam.requiresAuth: true})
  Future<NotificationsResponse> getUserNotifications({
    @Query("page") int? page,
    @Query("limit") int? limit,
  });
}
