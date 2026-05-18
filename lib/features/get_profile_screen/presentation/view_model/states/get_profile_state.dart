import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/get_profile_screen/domain/entities/user_entitiy.dart';


class GetProfileState extends Equatable {
  final BaseState<GetUserEntity> getProfileState;


  const GetProfileState({
    this.getProfileState = const BaseState(),

  });

  GetProfileState copyWith({
    BaseState<GetUserEntity>? getProfileState,

  }) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [
    getProfileState,

  ];
}
