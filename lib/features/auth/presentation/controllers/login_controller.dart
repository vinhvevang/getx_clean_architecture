
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/domain/usecases/login.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/login_page.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/main_page.dart';

class LoginController extends GetxController {
  final Login loginUseCase;
  LoginController(this.loginUseCase);

  final taxError      = Rxn<String>();
  final usernameError = Rxn<String>();
  final passwordError = Rxn<String>();

  void submit(String tax, String username, String password) {
    taxError.value = usernameError.value = passwordError.value = null;

    if (tax.isEmpty) {
      taxError.value = 'Không được để trống';
    } else if (int.tryParse(tax) == null) {
      taxError.value = 'Phải là số nguyên';
    }
    if (username.isEmpty) usernameError.value = 'Không được để trống';
    if (password.isEmpty) passwordError.value = 'Không được để trống';

    if (taxError.value != null ||
        usernameError.value != null ||
        passwordError.value != null) return;

    final ok = loginUseCase(int.parse(tax), username, password);
    if (ok) {
      Get.off(() => const MainPage());
    } else {
      taxError.value      = 'Sai thông tin đăng nhập';
      usernameError.value = 'Sai thông tin đăng nhập';
      passwordError.value = 'Sai thông tin đăng nhập';
    }
  }

  void logout() {
    taxError.value = usernameError.value = passwordError.value = null;
    Get.find<NavController>().reset();
    Get.offAll(() => LoginPage());
  }
}
