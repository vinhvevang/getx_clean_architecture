import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/filtered_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';

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

  /// INPUT
  final name = TextEditingController();
  final price = TextEditingController();
  final quan = TextEditingController();
  final image = TextEditingController();

  final editName = TextEditingController();
  final editPrice = TextEditingController();
  final editQuan = TextEditingController();
  final editImage = TextEditingController();

  final mincontroller = TextEditingController();
  final maxcontroller = TextEditingController();
  final findName = TextEditingController();

  /// STATE
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final isFiltering = false.obs;

  String _keyword = '';
  double? _minPrice;
  double? _maxPrice;
  Category _selectedCategory = Category.all;

  Category get selectedCategory => _selectedCategory;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    products.assignAll(getProductsUC());
    _applyFilter();
  }

  /// ================= HELPER =================
  double _parsePrice(String input) {
    final v = double.tryParse(input) ?? 0;
    return v < 1000 ? v * 1000 : v;
  }

  /// ================= FILTER =================
  void setCategory(Category c) {
    _selectedCategory = c;
    _applyFilter();
  }

  void applyFilter() {
    _minPrice = double.tryParse(mincontroller.text);
    _maxPrice = double.tryParse(maxcontroller.text);
    _applyFilter();
  }

  void clearFilter() {
    _keyword = '';
    _minPrice = null;
    _maxPrice = null;
    _selectedCategory = Category.all;

    findName.clear();
    mincontroller.clear();
    maxcontroller.clear();

    isFiltering.value = false;
    _applyFilter();
  }

  void find(String key) {
    _keyword = key;
    _applyFilter();
  }

  void _applyFilter() {
    final result = filterProductUC(
      products,
      keyword: _keyword,
      minPrice: _minPrice?.toInt(),
      maxPrice: _maxPrice?.toInt(),
      category: _selectedCategory,
    );

    filteredProducts.assignAll(result);

    isFiltering.value =
        _keyword.isNotEmpty ||
        _minPrice != null ||
        _maxPrice != null ||
        _selectedCategory != Category.all;
  }

  /// ================= CRUD =================
  void addProductSubmit(Category category, GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;

    addProductUC(
      Product(
        name.text,
        _parsePrice(price.text),
        double.parse(quan.text),
        image.text,
        category.name,
      ),
    );

    Get.back();
    _load();
    _clearAdd();
  }

  void editProductSubmit(
    int index,
    Category category,
    GlobalKey<FormState> formKey,
  ) {
    if (!formKey.currentState!.validate()) return;

    editProductUC(
      Product(
        editName.text,
        _parsePrice(editPrice.text),
        double.parse(editQuan.text),
        editImage.text,
        category.name,
      ),
      index,
    );

    Get.back();
    _load();
  }

  void remove(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // đóng dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                removeProductUC(index);
                _load();
                Navigator.pop(context); // đóng dialog
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _clearAdd() {
    name.clear();
    price.clear();
    quan.clear();
    image.clear();
  }

  /// ================= NAV / DIALOG =================
  void openAddDialog() {
    final formKey = GlobalKey<FormState>();
    Category selected = Category.shoes;

    Get.dialog(
      AlertDialog(
        title: const Text('Thêm sản phẩm'),
        content: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _input(name, 'Tên'),
                _input(price, 'Giá (100 = 100k)', isNum: true),
                _input(quan, 'Số lượng', isNum: true),
                _input(image, 'Link ảnh'),
                DropdownButtonFormField<Category>(
                  value: selected,
                  items:
                      Category.values
                          .where((c) => c != Category.all)
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.nameVi),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => selected = v!,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF24E1E)
            ),
            onPressed: () => addProductSubmit(selected, formKey),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void openEditDialog(Product old, int index) {
    final formKey = GlobalKey<FormState>();

    editName.text = old.name;
    editPrice.text = old.price.toString();
    editQuan.text = old.quan.toString();
    editImage.text = old.imageUrl;

    Category selected = Category.values.firstWhere(
      (e) => e.name == old.category,
      orElse: () => Category.shoes,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Sửa sản phẩm'),
        content: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _input(editName, 'Tên'),
                _input(editPrice, 'Giá (100 = 100k)', isNum: true),
                _input(editQuan, 'Số lượng', isNum: true),
                _input(editImage, 'Link ảnh'),
                DropdownButtonFormField<Category>(
                  value: selected,
                  items:
                      Category.values
                          .where((c) => c != Category.all)
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.nameVi),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => selected = v!,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF24E1E)
            ),
            onPressed: () => editProductSubmit(index, selected, formKey),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void openFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Bộ lọc'),
        content: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children:
                    Category.values.map((c) {
                      return ChoiceChip(
                        label: Text(c.nameVi),
                        selected: selectedCategory == c,
                        onSelected: (_) => setCategory(c),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
              _input(mincontroller, 'Giá từ', isNum: true),
              _input(maxcontroller, 'Giá đến', isNum: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearFilter();
              Get.back();
            },
            child: const Text('Xóa'),
          ),
          ElevatedButton(
            onPressed: () {
              applyFilter();
              Get.back();
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  /// reusable input
  Widget _input(TextEditingController c, String label, {bool isNum = false}) {
    return TextFormField(
      controller: c,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
    );
  }
}
