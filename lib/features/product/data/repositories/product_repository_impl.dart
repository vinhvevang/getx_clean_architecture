import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> products = [
    Product(
      "giày hôi",
      1000000,
      100,
      "https://giaycaosmartmen.com/wp-content/uploads/2020/11/cach-khu-mui-hoi-giay.jpg",
      "shoes",
    ),
    Product(
      "giày thơm",
      10000000,
      50,
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDB3Mm28qILpOVt04sMLqCelbCTrMz_NVVtLzUCA5utw&s=10",
      "shoes",
    ),
    Product(
      "giày da",
      999999,
      70,
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQJHeq7eSZBbYUC4HXuf6vCBA5r7rWUChlB6Zv5Bm-Kg&s=10",
      "shoes",
    ),
    Product(
      "áo thun",
      200000,
      20,
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlskcUqAFgFigNB4yiPu6u99EYCN2WFJa1uKM67RYWew&s=10",
      "clothes",
    ),
    Product(
      "iphone",
      20000000,
      5,
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlK4ahPBXYOMtD3MooJ7TQlg5h5yKP7LKvCPD44Wuuvg&s=10",
      "electronics",
    ),
  ];

  @override
  List<Product> getProducts() {
    return List.from(products); // 👈 tránh mutate trực tiếp
  }

  @override
  void addProduct(Product product) {
    products.add(product);
  }

  @override
  void editProduct(Product product, int index) {
    if (index >= 0 && index < products.length) {
      products[index] = product;
    }
  }

  @override
  void removeProduct(int index) {
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
    }
  }

  /// ❌ KHÔNG dùng nữa (để trống hoặc xóa khỏi interface)
  @override
  void filterProduct(int price) {}

  /// ❌ KHÔNG cần thiết (search đã làm ở UseCase)
  @override
  void findProduct(String name) {}
}
