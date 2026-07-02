import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mã số thuế (custom error right)
              AppTextFormField(
                controller: controller.tax,
                label: "Mã số thuế",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (controller.tax.text.isEmpty) {
                    return 'mã số thuế Không được để trống';
                  }
                  if (int.tryParse(controller.tax.text) != 11111) {
                    return "mã số thuế không hợp lệ";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Username
              AppTextFormField(
                controller: controller.username,
                label: "Tên đăng nhập",
                validator: (value) {
                  if (controller.username.text.isEmpty) {
                    return 'tài khoản Không được để trống';
                  }
                  if (controller.username.text != "demo") {
                    return "Sai tên tài khoản";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Password
              Obx(
                () => AppTextFormField(
                  controller: controller.password,
                  label: "Mật khẩu",
                  obscureText: controller.isOScured.value,
                  validator: (value) {
                    if (controller.password.text.isEmpty) {
                      return 'mật khẩu Không được để trống';
                    }
                    if (controller.password.text != "123456") {
                      return "Sai mật khẩu";
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

              // Button (Obx đúng chỗ)
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.handleIsLoading(),

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
