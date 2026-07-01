

import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl  implements ProductRepository{
   List<Product> _products = [];
   List<Product> _findProduct = [];
  @override
  List<Product> getProducts(){
      return _products;
  } 
   
  

  @override
  void addProduct(Product product) {
    // TODO: implement addProduct
    _products.add(product);
  }
  
  @override
  void editProduct(Product product, int i) {
    // TODO: implement editProduct
    _products[i] = product;
  }
  
  @override
  void filterProduct(int price) {
    // TODO: implement filterProduct
  }
  
  @override
  void findProduct(String name) {
    // TODO: implement findProduct
   _findProduct = _products.where((p)=> p.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
  
  @override
  void removeProduct(int id) {
    // TODO: implement removeProduct
    _products.removeAt(id);
  }

}