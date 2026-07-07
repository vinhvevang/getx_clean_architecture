import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';

/// Điều khiển form Thêm/Sửa sản phẩm. Dùng chung cho cả 2 thao tác (truyền
/// [initial] khi sửa) để không phải lặp lại field/validate/parse 2 lần.
///
/// Là object Dart thường, được HomeController tạo mới mỗi lần mở dialog và
/// truyền thẳng vào ProductFormDialog qua constructor (không qua Get.put/
/// Get.find) - widget luôn cầm đúng instance nó cần, không có "tra cứu" nào
/// có thể thất bại.
///
/// LƯU Ý: cố tình KHÔNG tự dispose() FocusNode/TextEditingController ở đây.
/// Dialog có animation đóng, và bàn phím ảo tắt giữa lúc đó làm dialog build
/// lại thêm 1-2 nhịp - dù delay 1 frame hay dùng Get.delete, dispose vẫn có
/// thể chạy sớm hơn lúc widget thật sự ngừng dùng tới các object này, gây lỗi
/// "used after disposed". Đây chỉ là vài object nhỏ, tạo mỗi lần mở dialog
/// (không phải hàng loạt), nên để Dart tự thu dọn khi không còn ai giữ tham
/// chiếu là lựa chọn an toàn và đơn giản hơn nhiều so với tự đoán thời điểm.
class ProductFormController {
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

  /// INPUT
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final imageUrlController = TextEditingController();

  final nameFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();

  /// STATE
  final hasAttemptedSubmit = false.obs;
  final selectedCategory = Rx<Category?>(null);

  final categoryOptions = Category.values.where((c) => c != Category.all).toList();

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

  /// Số lượng bắt buộc là số nguyên dương (1, 2, 3...), không nhận số thập
  /// phân, số 0 hay số âm.
  String? validateQuantity(String? value) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null) return 'Số lượng phải là số nguyên dương';
    if (parsed <= 0) return 'Số lượng phải lớn hơn 0';
    return null;
  }

  String? validateImageUrl(String? value) {
    final trimmed = (value ?? '').trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'Link ảnh không hợp lệ (phải bắt đầu bằng http/https)';
    }
    return null;
  }

  /// Validate toàn bộ form (bao gồm cả Dropdown danh mục, vì nó cũng là một
  /// FormField nằm trong cùng [formKey]). Trả về [Product] nếu hợp lệ, null
  /// nếu chưa.
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

  /// Quy ước nhập nhanh: nhập dưới 1000 nghĩa là "nghìn đồng" (100 = 100.000đ).
  double _parsePrice(String input) {
    final value = double.tryParse(input.trim()) ?? 0;
    return value < 1000 ? value * 1000 : value;
  }

  /// Bỏ ".0" thừa khi hiển thị số nguyên (VD: 100.0 -> "100"), vẫn giữ phần
  /// thập phân nếu giá trị thực sự có lẻ.
  String _formatNumberForInput(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }
}
