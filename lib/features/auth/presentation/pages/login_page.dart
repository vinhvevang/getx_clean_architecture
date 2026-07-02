import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          autovalidateMode:
              AutovalidateMode.disabled, // ❌ tắt auto validate toàn form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// TAX
              AppTextFormField(
                controller: controller.tax,
                label: "Mã số thuế",
                keyboardType: TextInputType.number,
                autovalidateMode:
                    AutovalidateMode.onUserInteraction, // ✅ chỉ field này
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  if (int.tryParse(value) != 11111) {
                    return 'Mã số thuế không hợp lệ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              /// USERNAME
              AppTextFormField(
                controller: controller.username,
                label: "Tên đăng nhập",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  if (value != "demo") {
                    return 'Sai tên tài khoản';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              /// PASSWORD
              Obx(
                () => AppTextFormField(
                  controller: controller.password,
                  label: "Mật khẩu",
                  obscureText: controller.isOScured.value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value != "123456") {
                      return 'Sai mật khẩu';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: controller.checkVisibility,
                    icon: Icon(
                      controller.isOScured.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                    ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Đăng nhập'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
