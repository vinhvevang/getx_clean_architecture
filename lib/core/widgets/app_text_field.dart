import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class AppTextFormField extends GetView<LoginController> {
  final TextEditingController controllerr;
  final String label;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final AutovalidateMode autovalidateMode;
  final bool isSubmitted;

  /// 🔥 thêm mới
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField({
    super.key,
    this.isSubmitted = false,
    required this.controllerr,
    required this.label,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onEditingComplete,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        controller.text.value = value ?? '';

        /// ✅ 1. luôn check rỗng
        if (controller.text.value.isEmpty) {
          return 'Không được để trống';
        }

        /// ✅ 2. chỉ check nghiệp vụ khi submit
        if (isSubmitted) {
          return validator(controller.text.value);
        }

        /// ❌ còn lại không hiện gì
        return null;
      },
      initialValue: controllerr.text,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: controllerr,
              obscureText: obscureText,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
             onChanged: (value) {
  state.didChange(value);

  /// 🔥 reset submit để không hiện lỗi nữa
  if (controller.isSubmitted.value) {
    controller.isSubmitted.value = false;
  }
},
              onEditingComplete: onEditingComplete,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: state.hasError ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: state.hasError ? Colors.red : Colors.blue,
                  ),
                ),

                /// 🔥 clear button
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controllerr.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controllerr.clear();
                          state.didChange('');
                        },
                      ),
                    if (suffixIcon != null) suffixIcon!,
                  ],
                ),
              ),
            ),

            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
