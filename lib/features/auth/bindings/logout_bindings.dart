import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/logout_controller.dart';

class LogoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogoutController>(() => LogoutController());
  }
}
