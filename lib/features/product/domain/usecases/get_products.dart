

import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

import '../entities/product.dart';


class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  List<Product> call() {
    return repository.getProducts();
  }
}