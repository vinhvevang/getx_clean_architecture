
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// TAX
              Obx(
                () => AppTextFormField(
                  controllerr: controller.tax,
                  label: "Mã số thuế",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  isSubmitted: controller.isSubmitted.value,

                  onEditingComplete: () => FocusScope.of(context).nextFocus(),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value != "11111") {
                      return 'Mã số thuế không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 12),

              /// USERNAME
              Obx(
                () => AppTextFormField(
                  controllerr: controller.username,
                  label: "Tên đăng nhập",

                  isSubmitted: controller.isSubmitted.value,

                  onEditingComplete: () => FocusScope.of(context).nextFocus(),

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
              ),

              const SizedBox(height: 12),

              /// PASSWORD
              Obx(
                () => AppTextFormField(
                  controllerr: controller.password,
                  label: "Mật khẩu",
                  obscureText: controller.isOScured.value,

                  isSubmitted: controller.isSubmitted.value,

                  onEditingComplete: controller.submit,

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

              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.submit,
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
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
