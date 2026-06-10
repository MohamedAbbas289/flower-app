import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/models/auth_response.dart';
import '../repositories/saves_address_repo_contract.dart';

@injectable
class SavedAddressUseCase {
  final SavesAddressRepoContract savedAddressRepoContract;
  SavedAddressUseCase(this.savedAddressRepoContract);

  Future <BaseResponse<AuthResponse>> call({String? token}){
    return savedAddressRepoContract.getSavedAddress(
      token:  token
    );
  }
  }

