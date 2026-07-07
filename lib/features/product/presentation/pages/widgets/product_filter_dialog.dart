import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/utils/app_input_formatters.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_filter_controller.dart';

/// Nhận [controller] trực tiếp qua constructor (không qua Get.find) để tránh
/// lỗi "not found" khi dialog đang trong lúc đóng lại.
class ProductFilterDialog extends StatelessWidget {
  final ProductFilterController controller;

  const ProductFilterDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bộ lọc'),
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: controller.formKey,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Chip danh mục dùng Rx: chạm vào là tick ngay, không cần chờ
                // bấm "Áp dụng" mới thấy phản hồi. showCheckmark: false để
                // chip KHÔNG đổi kích thước lúc chọn (dấu tick mặc định của
                // ChoiceChip làm chip phình ra, khiến cả hàng bị xô/"nhảy") -
                // giờ chỉ đổi màu nền/viền, kích thước cố định nên mượt hơn.
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: Category.values.map((c) {
                    final isSelected = controller.selectedCategory.value == c;
                    return ChoiceChip(
                      label: Text(c.nameVi),
                      selected: isSelected,
                      onSelected: (_) => controller.selectCategory(c),
                      showCheckmark: false,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: controller.minPriceController,
                  label: 'Giá từ',
                  hintText: 'Không giới hạn',
                  isRequired: false,
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [AppInputFormatters.positiveDecimal],
                  validator: controller.validatePriceField,
                  onChanged: (_) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: controller.maxPriceController,
                  label: 'Giá đến',
                  hintText: 'Không giới hạn',
                  isRequired: false,
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [AppInputFormatters.positiveDecimal],
                  validator: controller.validatePriceField,
                  onChanged: (_) => controller.onFieldChanged(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: controller.clear()),
          child: const Text('Xóa'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF24E1E)
          ),
          onPressed: () {
            final result = controller.apply();
            if (result != null) {
              Get.back(result: result);
            }
          },
          child: const Text('Áp dụng',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
