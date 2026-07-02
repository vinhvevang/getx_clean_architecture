import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class FilterProduct {
  final ProductRepository repository;

  FilterProduct(this.repository);

  List<Product> call({int? minPrice, int? maxPrice, String? keyword}) {
    final normalizedKeyword = keyword?.trim().toLowerCase() ?? '';

    return repository.getProducts().where((p) {
      final matchesMin = minPrice == null || p.price >= minPrice;
      final matchesMax = maxPrice == null || p.price <= maxPrice;
      final matchesKeyword =
          normalizedKeyword.isEmpty ||
          p.name.toLowerCase().contains(normalizedKeyword);
      return matchesMin && matchesMax && matchesKeyword;
    }).toList();
  }
}