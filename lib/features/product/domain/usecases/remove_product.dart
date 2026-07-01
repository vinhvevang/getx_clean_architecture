

import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class RemoveProduct{
  ProductRepository repository;
  RemoveProduct(this.repository);

  void call(int id){
    repository.removeProduct(id);
  }
}