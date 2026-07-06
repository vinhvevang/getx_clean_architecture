import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';

class FilterProduct {
  List<Product> call(
    List<Product> products, {
    int? minPrice,
    int? maxPrice,
    String? keyword,
    Category? category,
  }) {
    return products.where((p) {
      final matchKeyword = keyword == null || keyword.isEmpty
          ? true
          : p.name.toLowerCase().contains(keyword.toLowerCase());

      final matchMin = minPrice == null || p.price >= minPrice;
      final matchMax = maxPrice == null || p.price <= maxPrice;

      final matchCategory = category == null || category == Category.all
          ? true
          : p.category == category.name; // lưu dạng string

      return matchKeyword && matchMin && matchMax && matchCategory;
    }).toList();
  }
}
