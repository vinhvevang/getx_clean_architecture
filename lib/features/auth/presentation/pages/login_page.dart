import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/app_images.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

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
              /// LOGO GÓC TRÁI TRÊN
              Positioned(
                top: 0,
                right: 100,
                child: SizedBox(
                  width: 300,
                  child: SvgPicture.asset(
                    AppImages.biglogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              /// FORM Ở GIỮA
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 81),
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// TAX
                          Obx(
                            () => AppTextFormField(
                              controller: controller.tax,
                              label: "Mã số thuế",
                              isSubmitted: controller.isSubmitted.value,
                              focusNode: controller.taxFocus,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => controller.onChanged(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) => null,
                              onEditingComplete: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(controller.userFocus);
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// USERNAME
                          Obx(
                            () => AppTextFormField(
                              controller: controller.username,
                              label: "Tên đăng nhập",
                              isSubmitted: controller.isSubmitted.value,
                              focusNode: controller.userFocus,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => controller.onChanged(),
                              validator: (value) => null,
                              onEditingComplete: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(controller.passFocus);
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          Obx(
                            () => AppTextFormField(
                              controller: controller.password,
                              label: "Mật khẩu",
                              isSubmitted: controller.isSubmitted.value,
                              focusNode: controller.passFocus,
                              textInputAction: TextInputAction.done,
                              onChanged: (_) => controller.onChanged(),
                              obscureText: controller.isOScured.value,
                              validator: (value) => null,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                controller.submit();
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

                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Color(0xFFF24E1E),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF24E1E),
                                ),
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.submit,
                                child:
                                    controller.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : const Text('Đăng nhập'),
                              ),
                            ),
                          ),
                          // Spacer(),
                          SizedBox(height: 250),
                          Row(
                            children: [
                              Container(
                                height: 75,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: SvgPicture.asset(AppImages.headphones,fit: BoxFit.contain,)),
                                      Text("Tro giup",style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                              ),
                              SizedBox(width: 15,),
                              Container(
                                height: 75,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: SvgPicture.asset(AppImages.sociallinnk,fit: BoxFit.contain,)),
                                      Text("contact",style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                              ),
                              SizedBox(width: 15,),
                              Container(
                                height: 75,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: SvgPicture.asset(AppImages.searchnormal,fit: BoxFit.contain,)),
                                      Text("Tra cuu",style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                              ),
                            ],
                          )
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
