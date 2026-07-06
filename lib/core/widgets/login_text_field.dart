import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    required this.focusNode,
    this.nextFocus,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Obx(() => AppTextFormField(
          controller: controller,
          label: label,
          hintText: hintText,
          isSubmitted: loginController.hasAttemptedSubmit.value,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          obscureText: isPassword ? loginController.isPasswordObscured.value : false,

          onChanged: (_) => loginController.onFieldChanged(),

          textInputAction:
              nextFocus != null ? TextInputAction.next : TextInputAction.done,

          onEditingComplete: () {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              FocusScope.of(context).unfocus();
              loginController.submit();
            }
          },

          suffixIcon: isPassword
              ? IconButton(
                  onPressed: loginController.togglePasswordVisibility,
                  icon: Icon(
                    loginController.isPasswordObscured.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                )
              : null,
        ));
  }
}
