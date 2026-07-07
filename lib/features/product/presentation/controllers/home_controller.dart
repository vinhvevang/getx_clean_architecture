import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/widgets/confirm_dialog.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/filtered_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_filter_controller.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/product_form_controller.dart';
import 'package:getx_clean_archi/features/product/presentation/pages/widgets/product_filter_dialog.dart';
import 'package:getx_clean_archi/features/product/presentation/pages/widgets/product_form_dialog.dart';

class HomeController extends GetxController {
  final AddProduct addProductUC;
  final RemoveProduct removeProductUC;
  final EditProduct editProductUC;
  final GetProducts getProductsUC;
  final FilterProduct filterProductUC;

  HomeController({
    required this.filterProductUC,
    required this.addProductUC,
    required this.removeProductUC,
    required this.editProductUC,
    required this.getProductsUC,
  });

  /// Ô tìm kiếm - đọc trực tiếp searchController.text lúc lọc thay vì lưu
  /// thêm một biến "keyword" riêng dễ bị lệch với nội dung thật trên ô nhập.
  final searchController = TextEditingController();

  /// STATE
  final allProducts = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final hasActiveFilter = false.obs;

  final appliedCategory = Category.all.obs;
  final appliedMinPrice = Rx<double?>(null);
  final appliedMaxPrice = Rx<double?>(null);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _load() {
    allProducts.assignAll(getProductsUC());
    _applyFilter();
  }

  /// ================= TÌM KIẾM & LỌC =================
  void onSearchChanged(String _) => _applyFilter();

  void _applyFilter() {
    final keyword = searchController.text.trim();

    final result = filterProductUC(
      allProducts,
      keyword: keyword,
      minPrice: appliedMinPrice.value?.toInt(),
      maxPrice: appliedMaxPrice.value?.toInt(),
      category: appliedCategory.value,
    );

    filteredProducts.assignAll(result);

    hasActiveFilter.value =
        keyword.isNotEmpty ||
        appliedMinPrice.value != null ||
        appliedMaxPrice.value != null ||
        appliedCategory.value != Category.all;
  }

  /// Mở dialog bộ lọc. Chip danh mục trong dialog tick ngay khi chạm (Rx),
  /// nhưng [filteredProducts] chỉ thật sự đổi khi người dùng bấm "Áp dụng"
  /// hoặc "Xóa" - tức là khi dialog trả kết quả về đây.
  Future<void> openFilterDialog() async {
    final filterController = ProductFilterController(
      initialCategory: appliedCategory.value,
      initialMinPrice: appliedMinPrice.value,
      initialMaxPrice: appliedMaxPrice.value,
    );

    final result = await Get.dialog<ProductFilterResult>(
      ProductFilterDialog(controller: filterController),
    );

    if (result == null) return; // đóng bằng back/tap ra ngoài -> giữ nguyên

    if (result.cleared) {
      searchController.clear();
      appliedCategory.value = Category.all;
      appliedMinPrice.value = null;
      appliedMaxPrice.value = null;
    } else {
      appliedCategory.value = result.category;
      appliedMinPrice.value = result.minPrice;
      appliedMaxPrice.value = result.maxPrice;
    }

    _applyFilter();
  }

  void removeCategoryFilter() {
    appliedCategory.value = Category.all;
    _applyFilter();
  }

  void removePriceFilter() {
    appliedMinPrice.value = null;
    appliedMaxPrice.value = null;
    _applyFilter();
  }

  /// ================= CRUD SẢN PHẨM =================
  /// [ProductFormController] được tạo trực tiếp (không qua Get.put) và truyền
  /// thẳng vào dialog qua constructor -> mỗi lần mở luôn là form trắng/sạch
  /// hoàn toàn, và không phụ thuộc GetX tìm-theo-tên nên không thể "not found".
  Future<void> openAddDialog() async {
    final formController = ProductFormController();

    final product = await Get.dialog<Product>(
      ProductFormDialog(controller: formController),
    );

    if (product != null) {
      addProductUC(product);
      _load();
    }
  }

  Future<void> openEditDialog(Product product, int index) async {
    final formController = ProductFormController(initial: product);

    final updated = await Get.dialog<Product>(
      ProductFormDialog(controller: formController),
    );

    if (updated != null) {
      editProductUC(updated, index);
      _load();
    }
  }

  Future<void> confirmAndRemove(int index) async {
    final confirmed = await showConfirmDialog(
      title: 'Xác nhận',
      message: 'Bạn có chắc muốn xóa không?',
      confirmLabel: 'Xóa',
      isDestructive: true,
    );

    if (confirmed) {
      removeProductUC(index);
      _load();
    }
  }
}
