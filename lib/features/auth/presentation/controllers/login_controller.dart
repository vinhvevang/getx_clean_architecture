import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_clean_archi/features/auth/domain/usecases/login.dart';

class LoginController extends GetxController {
  final Login loginUseCase;
  LoginController(this.loginUseCase);

  /// INPUT
  final taxCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final taxCodeFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  /// STATE
  /// true kể từ lần bấm "Đăng nhập" đầu tiên -> từ đó validate theo thời gian thực.
  final hasAttemptedSubmit = false.obs;
  final isLoading = false.obs;
  final isPasswordObscured = true.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void onFieldChanged() {
    if (hasAttemptedSubmit.value) {
      formKey.currentState!.validate();
    }
  }

  /// Mã số thuế bắt buộc là số nguyên dương.
  String? validateTaxCode(String? value) {
    final trimmed = (value ?? '').trim();
    if (int.tryParse(trimmed) == null) return 'Mã số thuế không hợp lệ';
    return null;
  }

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!formKey.currentState!.validate()) return;

    final taxCode = int.tryParse(taxCodeController.text);
    if (taxCode == null) return;

    isLoading.value = true;

    // Giả lập độ trễ gọi API đăng nhập.
    await Future.delayed(const Duration(seconds: 1));

    final isAuthenticated = loginUseCase(
      taxCode,
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    if (isAuthenticated) {
      Get.offNamed('/main');
    } else {
      Get.snackbar("Lỗi", "Sai thông tin đăng nhập");
    }
  }

  @override
  void onClose() {
    taxCodeController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    taxCodeFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();

    super.onClose();
  }
}
