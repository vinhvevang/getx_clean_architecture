import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';

/// Kết quả trả về khi đóng dialog lọc: hoặc người dùng bấm "Xóa" (reset toàn
/// bộ, kể cả từ khóa tìm kiếm) hoặc bấm "Áp dụng" với các giá trị đã chọn.
class ProductFilterResult {
  final bool cleared;
  final Category category;
  final double? minPrice;
  final double? maxPrice;

  const ProductFilterResult.applied({
    required this.category,
    required this.minPrice,
    required this.maxPrice,
  }) : cleared = false;

  const ProductFilterResult.cleared()
      : cleared = true,
        category = Category.all,
        minPrice = null,
        maxPrice = null;
}

/// Điều khiển dialog Bộ lọc. [selectedCategory] là Rx nên chip danh mục
/// tick/bỏ tick ngay khi chạm (UI phản hồi tức thì), nhưng danh sách sản
/// phẩm thật sự chỉ được cập nhật khi HomeController nhận [ProductFilterResult]
/// lúc dialog đóng bằng nút "Áp dụng" - xem HomeController.openFilterDialog.
///
/// Là object Dart thường (không qua Get.put/Get.find) - lý do xem chú thích
/// trong ProductFormController.
class ProductFilterController extends GetxController {
  ProductFilterController({
    required Category initialCategory,
    double? initialMinPrice,
    double? initialMaxPrice,
  }) : selectedCategory = initialCategory.obs {
    if (initialMinPrice != null) {
      minPriceController.text = _formatNumberForInput(initialMinPrice);
    }
    if (initialMaxPrice != null) {
      maxPriceController.text = _formatNumberForInput(initialMaxPrice);
    }
  }

  final formKey = GlobalKey<FormState>();

  final Rx<Category> selectedCategory;
  final hasAttemptedSubmit = false.obs;

  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  void selectCategory(Category category) => selectedCategory.value = category;

  void onFieldChanged() {
    if (hasAttemptedSubmit.value) {
      formKey.currentState?.validate();
    }
  }

  /// Giá từ/đến đều là field tùy chọn: bỏ trống là hợp lệ, nhưng nếu đã nhập
  /// thì phải là số, và "từ" phải nhỏ hơn hoặc bằng "đến".
  String? validatePriceField(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    if (double.tryParse(trimmed) == null) return 'Giá không hợp lệ';

    final min = double.tryParse(minPriceController.text.trim());
    final max = double.tryParse(maxPriceController.text.trim());
    if (min != null && max != null && min > max) {
      return 'Giá từ phải ≤ giá đến';
    }
    return null;
  }

  /// Trả về kết quả áp dụng nếu form hợp lệ, null nếu chưa (để dialog biết
  /// không nên đóng).
  ProductFilterResult? apply() {
    hasAttemptedSubmit.value = true;
    if (!formKey.currentState!.validate()) return null;

    return ProductFilterResult.applied(
      category: selectedCategory.value,
      minPrice: double.tryParse(minPriceController.text.trim()),
      maxPrice: double.tryParse(maxPriceController.text.trim()),
    );
  }

  ProductFilterResult clear() => const ProductFilterResult.cleared();

  String _formatNumberForInput(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  /// Gọi thủ công khi đóng dialog (xem HomeController).
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
  }
  @override
void onClose() {
  minPriceController.dispose();
  maxPriceController.dispose();
  super.onClose();
}
}
