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

  final isLoading = false.obs;
  final error = Rxn<String>();

  Future<void> submit() async {
    error.value = null;

    final taxNumber = int.tryParse(tax.text);

   
    if (taxNumber == null) {
      error.value = 'Mã số thuế không hợp lệ';
      return;
    }

    isLoading.value = true;

   
    await Future.delayed(const Duration(seconds: 1));

    final isAuth = loginUseCase(
      taxNumber,
      username.text,
      password.text,
    );

    isLoading.value = false;

    if (isAuth) {
      Get.off(() => const MainPage());
    } else {
      error.value = 'Sai thông tin đăng nhập';
    }
  }

  void logout() {
    error.value = null;
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