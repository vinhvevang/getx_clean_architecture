import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:getx_clean_archi/features/auth/domain/usecases/login.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    final authRepository = AuthRepositoryImpl();
    final loginUseCase = Login(authRepository);

    Get.lazyPut<LoginController>(() => LoginController(loginUseCase));
  }
}