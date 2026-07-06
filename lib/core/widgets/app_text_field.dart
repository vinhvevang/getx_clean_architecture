import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool isSubmitted;

  /// Khi false, field được coi là tùy chọn: bỏ qua kiểm tra "không được để trống"
  /// mặc định, chỉ chạy [validator] tùy chỉnh (nếu có) khi người dùng có nhập.
  final bool isRequired;

  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.isSubmitted = false,
    this.isRequired = true,
    this.onEditingComplete,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

      autovalidateMode: isSubmitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,

      onChanged: onChanged,
      onEditingComplete: onEditingComplete,

      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Không được để trống';
        }
        return validator?.call(value);
      },

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),

        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.clear,
                  ),
                if (suffixIcon != null) suffixIcon!,
              ],
            );
          },
        ),
      ),
    );
  }
}
