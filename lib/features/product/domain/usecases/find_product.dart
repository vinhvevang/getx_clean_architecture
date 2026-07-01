

import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class FindProduct {
  final ProductRepository repository;

  FindProduct(this.repository);

  List<Product> call(String keyword) {
    return repository
        .getProducts()
        .where((p) =>
            p.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}