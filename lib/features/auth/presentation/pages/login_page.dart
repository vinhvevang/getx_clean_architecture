import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/app_images.dart';
import 'package:getx_clean_archi/core/utils/app_input_formatters.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/login_text_field.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              /// LOGO
              Positioned(
                top: 0,
                right: 100,
                child: SizedBox(
                  width: 300,
                  child: SvgPicture.asset(
                    AppImages.bigLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// FORM
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 81),
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          LoginTextField(
                            controller: controller.taxCodeController,
                            label: "Mã số thuế",
                            hintText: "Nhập mã số thuế",
                            focusNode: controller.taxCodeFocusNode,
                            nextFocus: controller.usernameFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [AppInputFormatters.positiveInteger],
                            validator: controller.validateTaxCode,
                          ),

                          const SizedBox(height: 20),

                          LoginTextField(
                            controller: controller.usernameController,
                            label: "Tên đăng nhập",
                            hintText: "Nhập tên đăng nhập",
                            focusNode: controller.usernameFocusNode,
                            nextFocus: controller.passwordFocusNode,
                          ),

                          const SizedBox(height: 20),

                          LoginTextField(
                            controller: controller.passwordController,
                            label: "Mật khẩu",
                            hintText: "Nhập mật khẩu",
                            focusNode: controller.passwordFocusNode,
                            isPassword: true,
                          ),

                          const SizedBox(height: 24),

                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.submit,
                                child:
                                    controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          'Đăng nhập',
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 200),

                          /// FOOTER
                          const Row(
                            children: [
                              _LoginFooterItem(
                                iconAsset: AppImages.headphones,
                                label: "Trợ giúp",
                              ),
                              SizedBox(width: 15),
                              _LoginFooterItem(
                                iconAsset: AppImages.socialLink,
                                label: "Contact",
                              ),
                              SizedBox(width: 15),
                              _LoginFooterItem(
                                iconAsset: AppImages.searchNormal,
                                label: "Tra cứu",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

/// Một ô ở thanh footer (icon + nhãn). Trước đây 3 ô này được viết lặp lại
/// y hệt nhau bằng Container/Row thủ công; giờ gộp về một widget dùng chung.
class _LoginFooterItem extends StatelessWidget {
  final String iconAsset;
  final String label;

  const _LoginFooterItem({required this.iconAsset, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
          ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
