import 'package:flower_app/features/get_profile_screen/data/models/get_user_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_model.dart';
part  'get_profile_response.g.dart';
@JsonSerializable()

class GetProfileResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  GetUserDto? getUserDto;

  GetProfileResponse({
    this.message,
    this.getUserDto,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => _$GetProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);

}




