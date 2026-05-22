import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import '../../../domain/entities/edit_user_entity.dart';


class UpdateProfileState extends Equatable {
  final BaseState<EditUserEntity> updateProfileState;


  const UpdateProfileState({
    this.updateProfileState = const BaseState(),

  });

  UpdateProfileState copyWith({
    BaseState<EditUserEntity>? updateProfileState,

  }) {
    return UpdateProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
  ];
}
