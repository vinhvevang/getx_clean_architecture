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

  /// Nếu có: nhấn Enter/Next sẽ tự chuyển focus sang field này, không cần tự
  /// viết FocusScope.of(context).requestFocus(...) ở nơi gọi nữa.
  final FocusNode? nextFocus;

  /// Nếu có (và [nextFocus] không có - tức đây là field cuối cùng): nhấn
  /// Enter/Done sẽ ẩn bàn phím rồi gọi callback này. Dùng để "nhập xong field
  /// cuối, nhấn Enter là submit luôn" mà không phải lặp logic ở từng dialog.
  final VoidCallback? onSubmit;

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
    this.nextFocus,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextInputAction =
        textInputAction ??
        (nextFocus != null
            ? TextInputAction.next
            : (onSubmit != null ? TextInputAction.done : null));

    void handleEditingComplete() {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      } else if (onSubmit != null) {
        FocusScope.of(context).unfocus();
        onSubmit!();
      }
      onEditingComplete?.call();
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: effectiveTextInputAction,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

      autovalidateMode: isSubmitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,

      onChanged: onChanged,
      onEditingComplete:
          (nextFocus != null || onSubmit != null || onEditingComplete != null)
          ? handleEditingComplete
          : null,

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
