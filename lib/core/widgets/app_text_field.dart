import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class AppTextFormField extends StatelessWidget {
final TextEditingController controller;
final String label;
final String? Function(String?) validator;
final bool obscureText;
final Widget? suffixIcon;
final TextInputType? keyboardType;
final bool isSubmitted;

final VoidCallback? onEditingComplete;
final List<TextInputFormatter>? inputFormatters;

/// 🔥 thêm
final FocusNode? focusNode;
final TextInputAction? textInputAction;
final Function(String)? onChanged;

const AppTextFormField({
super.key,
required this.controller,
required this.label,
required this.validator,
this.obscureText = false,
this.suffixIcon,
this.keyboardType,
this.isSubmitted = false,
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

  /// 🔥 fix realtime validate
  autovalidateMode: isSubmitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled,

  onChanged: onChanged,

  onEditingComplete: onEditingComplete,

  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống';
    }
    return validator(value);
  },

  decoration: InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelText: label,
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
                onPressed: () {
                  controller.clear();
                },
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
