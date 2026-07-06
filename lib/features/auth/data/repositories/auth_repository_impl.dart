import 'package:getx_clean_archi/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  bool login(int taxCode, String username, String password) {
    return taxCode == 11111 && username == 'demo' && password == '123456';
  }
}
