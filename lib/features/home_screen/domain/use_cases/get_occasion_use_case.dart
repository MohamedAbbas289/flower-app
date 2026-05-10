
import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../repositories/home_repo_contract.dart';

@injectable
class GetOccasionUseCase {

  final HomeRepoContract homeRepoContract;

  GetOccasionUseCase(this.homeRepoContract);


  Future<BaseResponse<List<OccasionModel>>> call () async {
    return  await homeRepoContract.getAllOccasion();
  }
}