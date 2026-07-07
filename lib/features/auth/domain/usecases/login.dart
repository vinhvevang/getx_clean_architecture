import 'package:getx_clean_archi/features/auth/domain/repository/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  bool call(int taxCode, String username, String password) {
    return repository.login(taxCode, username, password);
  }
}
