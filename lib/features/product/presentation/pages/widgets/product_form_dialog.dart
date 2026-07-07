import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/utils/app_input_formatters.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_form_controller.dart';

/// Dialog Thêm/Sửa sản phẩm dùng chung — chỉ khác tiêu đề/nhãn nút, dựa vào
/// [ProductFormController.isEditing]. Tương tác giống màn Login: focus chain
/// giữa các field (Enter -> field kế tiếp), field cuối nhấn Enter là submit
/// luôn - nhờ AppTextFormField.nextFocus/onSubmit nên không phải tự viết
/// FocusScope.of(context).requestFocus(...) lặp lại ở từng field nữa.
///
/// Nhận [controller] trực tiếp qua constructor (không qua Get.find) để tránh
/// lỗi "not found" khi dialog đang trong lúc đóng lại.
class ProductFormDialog extends StatelessWidget {
  final ProductFormController controller;

  const ProductFormDialog({super.key, required this.controller});

  void _handleSubmit() {
    final product = controller.submit();
    if (product != null) {
      Get.back<Product>(result: product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(controller.isEditing ? 'Sửa sản phẩm' : 'Thêm sản phẩm'),
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
                AppTextFormField(
                  controller: controller.nameController,
                  label: 'Tên sản phẩm',
                  hintText: 'Nhập tên sản phẩm',
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  focusNode: controller.nameFocusNode,
                  nextFocus: controller.priceFocusNode,
                  onChanged: (_) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: controller.priceController,
                  label: 'Giá',
                  hintText: 'VD: 100 = 100.000đ',
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [AppInputFormatters.positiveDecimal],
                  validator: controller.validatePrice,
                  focusNode: controller.priceFocusNode,
                  nextFocus: controller.quantityFocusNode,
                  onChanged: (_) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: controller.quantityController,
                  label: 'Số lượng',
                  hintText: 'Nhập số lượng tồn kho',
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [AppInputFormatters.positiveInteger],
                  validator: controller.validateQuantity,
                  focusNode: controller.quantityFocusNode,
                  nextFocus: controller.imageUrlFocusNode,
                  onChanged: (_) => controller.onFieldChanged(),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: controller.imageUrlController,
                  label: 'Link ảnh',
                  hintText: 'https://...',
                  isSubmitted: controller.hasAttemptedSubmit.value,
                  keyboardType: TextInputType.url,
                  validator: controller.validateImageUrl,
                  focusNode: controller.imageUrlFocusNode,
                  onChanged: (_) => controller.onFieldChanged(),
                  // Field cuối cùng: nhấn Enter/Done coi như bấm nút Thêm/Lưu.
                  onSubmit: _handleSubmit,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Category>(
                  value: controller.selectedCategory.value,
                  hint: const Text('Chọn danh mục'),
                  items: controller.categoryOptions
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.nameVi),
                        ),
                      )
                      .toList(),
                  onChanged: controller.selectCategory,
                  validator: controller.validateCategory,
                  autovalidateMode: controller.hasAttemptedSubmit.value
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _handleSubmit,
          child: Text(controller.isEditing ? 'Lưu' : 'Thêm',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
