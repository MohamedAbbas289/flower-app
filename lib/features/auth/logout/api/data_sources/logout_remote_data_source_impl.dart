import 'package:injectable/injectable.dart';

import '../../data/data_sources/logout_remote_data_source.dart';
import '../logout_api_client/logout_api_client.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final LogoutApiClient _logoutApiClient;

  LogoutRemoteDataSourceImpl(this._logoutApiClient);

  @override
  Future<void> logout() {
    return _logoutApiClient.logout();
  }
}
