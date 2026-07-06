

import 'package:flutter/material.dart' show Dialog, DropdownButtonFormField, DropdownMenuItem, ElevatedButton, InputDecoration, TextButton, TextFormField, Widget;
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart' show Obx;
import 'package:get/get_state_manager/src/simple/get_view.dart' show GetView;
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_form_controller.dart' show ProductFormController;

class ProductFormDialog extends GetView<ProductFormController> {
const ProductFormDialog({super.key});

@override
Widget build(BuildContext context) {
return Dialog(
child: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Form(
key: controller.formKey,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
/// ===== NAME =====
TextFormField(
controller: controller.nameController,
focusNode: controller.nameFocusNode,
decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
onChanged: (_) => controller.onFieldChanged(),
validator: (v) =>
v == null || v.trim().isEmpty ? 'Không được để trống' : null,
),

          /// ===== PRICE =====
          TextFormField(
            controller: controller.priceController,
            focusNode: controller.priceFocusNode,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Giá'),
            onChanged: (_) => controller.onFieldChanged(),
            validator: controller.validatePrice,
          ),

          /// ===== QUANTITY =====
          TextFormField(
            controller: controller.quantityController,
            focusNode: controller.quantityFocusNode,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Số lượng'),
            onChanged: (_) => controller.onFieldChanged(),
            validator: controller.validateQuantity,
          ),

          /// ===== IMAGE =====
          TextFormField(
            controller: controller.imageUrlController,
            focusNode: controller.imageUrlFocusNode,
            decoration: const InputDecoration(labelText: 'Image URL'),
            onChanged: (_) => controller.onFieldChanged(),
            validator: controller.validateImageUrl,
          ),

          const SizedBox(height: 12),

          /// ===== CATEGORY =====
          Obx(() {
            return DropdownButtonFormField<Category>(
              value: controller.selectedCategory.value,
              items: controller.categoryOptions
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.nameVi),
                    ),
                  )
                  .toList(),
              onChanged: controller.selectCategory,
              decoration:
                  const InputDecoration(labelText: 'Danh mục'),
              validator: controller.validateCategory,
            );
          }),

          const SizedBox(height: 20),

          /// ===== BUTTON =====
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Hủy'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final product = controller.submit();
                  if (product != null) {
                    Get.back(result: product);
                  }
                },
                child: Text(
                  controller.isEditing ? 'Cập nhật' : 'Thêm',
                ),
              ),
            ],
          )
        ],
      ),
    ),
  ),
);

}
}