import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/domain/usecases/login.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/login_page.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/main_page.dart';

class LoginController extends GetxController {
final Login loginUseCase;
LoginController(this.loginUseCase);

final tax = TextEditingController();
final username = TextEditingController();
final password = TextEditingController();

final formKey = GlobalKey<FormState>();

final isLoading = false.obs;
final isOScured = true.obs;

void checkVisibility() {
isOScured.value = !isOScured.value;
}

Future<void> submit() async {
/// VALIDATE FORM TRƯỚC
if (!formKey.currentState!.validate()) return;


final taxNumber = int.tryParse(tax.text);
if (taxNumber == null) return;

try {
  isLoading.value = true;

  await Future.delayed(const Duration(seconds: 1));

  final isAuth = loginUseCase(
    taxNumber,
    username.text.trim(),
    password.text.trim(),
  );

  if (isAuth) {
    Get.off(() => const MainPage());
  } else {
    Get.snackbar("Lỗi", "Thông tin đăng nhập không đúng");
  }
} catch (e) {
  Get.snackbar("Error", "Có lỗi xảy ra");
} finally {
  isLoading.value = false;
}


}

void logout() {
Get.find<NavController>().reset();
Get.offAll(() => LoginPage());
}

@override
void onClose() {
tax.dispose();
username.dispose();
password.dispose();
super.onClose();
}
}
