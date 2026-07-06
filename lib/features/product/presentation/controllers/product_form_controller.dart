

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart' show Product;

class ProductFormController extends GetxController {
  ProductFormController({Product? initial}) : isEditing = initial != null {
    if (initial != null) {
      nameController.text = initial.name;
      priceController.text = _formatNumberForInput(initial.price);
      quantityController.text = _formatNumberForInput(initial.quantity);
      imageUrlController.text = initial.imageUrl;

      selectedCategory.value = Category.values.firstWhere(
        (c) => c.name == initial.category,
        orElse: () => Category.shoes,
      );
    }
  }

  final bool isEditing;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final imageUrlController = TextEditingController();

  final nameFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();

  final hasAttemptedSubmit = false.obs;
  final selectedCategory = Rx<Category?>(null);

  final categoryOptions =
      Category.values.where((c) => c != Category.all).toList();

  void onFieldChanged() {
    if (hasAttemptedSubmit.value) {
      formKey.currentState?.validate();
    }
  }

  void selectCategory(Category? category) => selectedCategory.value = category;

  String? validateCategory(Category? value) {
    return value == null ? 'Vui lòng chọn danh mục' : null;
  }

  String? validatePrice(String? value) {
    final parsed = double.tryParse((value ?? '').trim());
    if (parsed == null) return 'Giá không hợp lệ';
    if (parsed <= 0) return 'Giá phải lớn hơn 0';
    return null;
  }

  String? validateQuantity(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null) return 'Số lượng phải là số nguyên dương';
    if (parsed <= 0) return 'Số lượng phải lớn hơn 0';
    return null;
  }

  String? validateImageUrl(String? value) {
    final trimmed = (value ?? '').trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'Link ảnh không hợp lệ';
    }
    return null;
  }

  Product? submit() {
    hasAttemptedSubmit.value = true;

    if (!formKey.currentState!.validate()) return null;

    return Product(
      nameController.text.trim(),
      _parsePrice(priceController.text),
      double.parse(quantityController.text.trim()),
      imageUrlController.text.trim(),
      selectedCategory.value!.name,
    );
  }

  double _parsePrice(String input) {
    final value = double.tryParse(input.trim()) ?? 0;
    return value < 1000 ? value * 1000 : value;
  }

  String _formatNumberForInput(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    imageUrlController.dispose();

    nameFocusNode.dispose();
    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    imageUrlFocusNode.dispose();

    super.onClose();
  }
}
