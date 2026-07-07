import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';


class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(() => NavController());
  }
}