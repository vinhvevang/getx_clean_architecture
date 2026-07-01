import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/filtered_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/find_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';

class HomeController extends GetxController {
  final AddProduct addProductUC;
  final RemoveProduct removeProductUC;
  final EditProduct editProductUC;
  final FindProduct findProductUC;
  final GetProducts getProductsUC;
  final FilterProduct filterProductUC;

  HomeController({
    required this.addProductUC,
    required this.removeProductUC,
    required this.editProductUC,
    required this.findProductUC,
    required this.getProductsUC,
    required this.filterProductUC,
  });
  final TextEditingController name = TextEditingController();
  final price = TextEditingController();
  final quan = TextEditingController();
  final editName = TextEditingController();
  final editPrice = TextEditingController();
  final editQuan = TextEditingController();
  final findName = TextEditingController();

  // Danh sách reactive
  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;

  String _keyword = '';
  int? _minPrice;
  int? _maxPrice;

  // Áp dụng cả tìm kiếm lẫn lọc giá
  void _applyFilters() {
    filteredProducts.assignAll(
      getProductsUC().where((p) {
        final matchName = p.name.toLowerCase().contains(_keyword.toLowerCase());
        final matchMin = _minPrice == null || p.price >= _minPrice!;
        final matchMax = _maxPrice == null || p.price <= _maxPrice!;
        return matchName && matchMin && matchMax;
      }).toList(),
    );
  }

  void _refreshAll() {
    products.assignAll(getProductsUC());
    _applyFilters();
  }

  void add(Product p) {
    addProductUC(p);
    _refreshAll();
  }

  void remove(int index) {
    removeProductUC(index);
    _refreshAll();
  }

  void edit(Product p, int idx) {
    editProductUC(p, idx);
    _refreshAll();
  }

  void find(String keyword) {
    _keyword = keyword;
    _applyFilters();
  }

  void filter({int? minPrice, int? maxPrice}) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _applyFilters();
  }
}
