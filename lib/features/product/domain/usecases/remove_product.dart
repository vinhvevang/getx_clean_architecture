import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class RemoveProduct {
  final ProductRepository repository;
  RemoveProduct(this.repository);

  void call(int index) {
    repository.removeProduct(index);
  }
}
