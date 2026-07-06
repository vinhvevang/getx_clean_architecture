import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/utils/app_input_formatters.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_filter_controller.dart';

class ProductFilterDialog extends GetView<ProductFilterController> {
  const ProductFilterDialog({super.key});

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
                Wrap(
                  spacing: 8,
                  children:
                      Category.values.map((c) {
                        return ChoiceChip(
                          label: Text(c.nameVi),
                          selected: controller.selectedCategory.value == c,
                          onSelected: (bool selected) {
                            controller.selectCategory(c);
                          },
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
                  onChanged: (String value) {
                    controller.onFieldChanged();
                  },
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
                  onChanged: (String value) {
                    controller.onFieldChanged();
                  },
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
          onPressed: () {
            final result = controller.apply();
            if (result != null) {
              Get.back(result: result);
            }
          },
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }
}
