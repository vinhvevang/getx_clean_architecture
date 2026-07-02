import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final List<Product> products = [Product("giày hôi", 1000000, 100),
 Product("giày thơm", 10000000, 50),
   Product("giày da", 999999, 70),
   Product("giày bata ", 100000, 1000)];

  List<Product> _findProduct = [];
  @override
  List<Product> getProducts() {
 
    return products;
  }

  @override
  void addProduct(Product product) {
    // TODO: implement addProduct
    products.add(product);
  }

  @override
  void editProduct(Product product, int index) {
    if (index >= 0 && index < products.length) {
      products[index] = product;
    }
  }

  @override
  void filterProduct(int price) {
    // TODO: implement filterProduct
  }

  @override
  void findProduct(String name) {
    // TODO: implement findProduct
    _findProduct =
        products
            .where((p) => p.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
  }

  @override
  void removeProduct(int id) {
    // TODO: implement removeProduct
    products.removeAt(id);
  }
}
