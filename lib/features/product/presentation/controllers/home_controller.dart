import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';

class HomeController extends GetxController {
  final AddProduct addProductUC;
  final RemoveProduct removeProductUC;
  final EditProduct editProductUC;
  final GetProducts getProductsUC;

  HomeController({
    required this.addProductUC,
    required this.removeProductUC,
    required this.editProductUC,
    required this.getProductsUC,
  });

  /// INPUT
  final name = TextEditingController();
  final price = TextEditingController();
  final quan = TextEditingController();

  final editName = TextEditingController();
  final editPrice = TextEditingController();
  final editQuan = TextEditingController();

  final findName = TextEditingController();
  final mincontroller = TextEditingController();
  final maxcontroller = TextEditingController();

  /// STATE
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;

  String _keyword = '';
  double? _minPrice;
  double? _maxPrice;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    products.assignAll(getProductsUC());
    _applyFilters();
  }

  void _applyFilters() {
    final result =
        products.where((p) {
          final matchName = p.name.toLowerCase().contains(
            _keyword.toLowerCase(),
          );

          final matchMin = _minPrice == null || p.price >= _minPrice!;
          final matchMax = _maxPrice == null || p.price <= _maxPrice!;

          return matchName && matchMin && matchMax;
        }).toList();

    filteredProducts.assignAll(result);
  }

  /// ACTIONS
  void add(Product p) {
    addProductUC(p);
    _loadProducts();
    name.clear();
    price.clear();
    quan.clear();
  }

  void remove(int index) {
    removeProductUC(index);
    _loadProducts();
  }

  void edit(Product p, int index) {
    if (index < 0 || index >= products.length) return;

    editProductUC(p, index);
    products[index] = p;
    _applyFilters();
  }

  void find(String keyword) {
    _keyword = keyword;
    _applyFilters();
  }

  void apply() {
    _minPrice = double.tryParse(mincontroller.text);
    _maxPrice = double.tryParse(maxcontroller.text);
    _applyFilters();
  }

  void clearFilter() {
    _minPrice = null;
    _maxPrice = null;
    mincontroller.clear();
    maxcontroller.clear();
    _applyFilters();
  }
}
