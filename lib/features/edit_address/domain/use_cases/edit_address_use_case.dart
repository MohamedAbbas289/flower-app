import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/edit_address/domain/repositories_contract/edit_address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditAddressUseCase {
  final EditAddressRepoContract _repo;

  EditAddressUseCase(this._repo);

  Future<BaseResponse<List<AddressEntity>>> call({
    required String id,
    required AddAddressDto request,
  }) async {
    return await _repo.editAddress(id: id, request: request);
  }
}