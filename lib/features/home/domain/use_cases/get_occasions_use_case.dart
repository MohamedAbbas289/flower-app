import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOccasionsUseCase {
  GetOccasionsUseCase(this._repository);
  final HomeRepositoryContract _repository;

  Future<BaseResponse<OccasionsEntity>> execute({
    required int page,
    required int limit,
  }) async {
    return await _repository.getOccasions(page: page, limit: limit);
  }
}
