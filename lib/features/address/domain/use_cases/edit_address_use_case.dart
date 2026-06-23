import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditAddressUseCase {
  final AddressRepositoryContract _repo;

  EditAddressUseCase(this._repo);

  Future<BaseResponse<List<AddressEntity>>> call({
    required String id,
    required AddAddressDto request,
  }) async {
    return await _repo.editAddress(id: id, request: request);
  }
}