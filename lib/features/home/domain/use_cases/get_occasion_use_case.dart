import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetOccasionUseCase {
  final HomeRepositoryContract homeRepoContract;

  GetOccasionUseCase(this.homeRepoContract);

  Future<BaseResponse<List<HomeOccasionEntity>>> call() async {
    return homeRepoContract.getAllOccasion();
  }
}
