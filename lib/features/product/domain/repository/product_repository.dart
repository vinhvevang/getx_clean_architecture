import 'package:getx_clean_archi/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();
  void addProduct(Product product);
  void removeProduct(int index);
  void editProduct(Product product, int index);
}
