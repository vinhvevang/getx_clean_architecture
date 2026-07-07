import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';

/// Chỉ chịu trách nhiệm đăng xuất, tách riêng khỏi NavController (quản lý tab)
/// và LoginController (vòng đời chỉ gắn với màn hình '/login').
/// Vì được bind cùng '/main' nên vẫn còn sống suốt phiên đăng nhập, và tự bị
/// GetX hủy khi rời '/main' (offAllNamed xóa toàn bộ stack, không cần dispose gì).
class LogoutController extends GetxController {
  void logout() {
    Get.find<NavController>().resetTab();

    // offAllNamed dọn sạch stack hiện tại ('/main' cùng mọi controller được
    // bind ở đó) rồi điều hướng qua route '/login', khiến LoginBinding chạy
    // lại và tạo LoginController mới hoàn toàn sạch cho lần đăng nhập kế tiếp.
    Get.offAllNamed('/login');
  }
}
