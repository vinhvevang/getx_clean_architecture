import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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

final taxFocus = FocusNode();
final userFocus = FocusNode();
final passFocus = FocusNode();

final isSubmitted = false.obs;
final formKey = GlobalKey<FormState>();
final isLoading = false.obs;
final isOScured = true.obs;

void checkVisibility() {
isOScured.value = !isOScured.value;
}

void onChanged() {
if (isSubmitted.value) {
formKey.currentState!.validate();
}
}

Future<void> submit() async {
isSubmitted.value = true;


if (!formKey.currentState!.validate()) return;

final taxNumber = int.tryParse(tax.text);
if (taxNumber == null) return;

isLoading.value = true;

await Future.delayed(const Duration(seconds: 1));

final isAuth = loginUseCase(
  taxNumber,
  username.text.trim(),
  password.text.trim(),
);

isLoading.value = false;

if (isAuth) {
  Get.off(() => const MainPage());
} else {
  Get.snackbar("Lỗi", "Sai thông tin đăng nhập");
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


taxFocus.dispose();
userFocus.dispose();
passFocus.dispose();

super.onClose();


}
}
