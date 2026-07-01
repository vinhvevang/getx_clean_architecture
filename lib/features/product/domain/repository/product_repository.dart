
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  List<Product> getProducts();
  void addProduct(Product product);
  void removeProduct(int id);
  void editProduct(Product product,int id);
  void findProduct(String name);
  void filterProduct(int price);
}