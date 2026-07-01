
import 'package:getx_clean_archi/features/auth/domain/repository/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  bool call(int tax, String username, String password) {
    return repository.login(tax, username, password);
  }
}
