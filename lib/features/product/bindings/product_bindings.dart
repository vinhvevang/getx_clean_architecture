import 'package:get/get.dart';
import 'package:getx_clean_archi/features/product/data/repositories/product_repository_impl.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/filtered_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final productRepository = ProductRepositoryImpl();

    Get.lazyPut(() => AddProduct(productRepository));
    Get.lazyPut(() => RemoveProduct(productRepository));
    Get.lazyPut(() => EditProduct(productRepository));
    Get.lazyPut(() => GetProducts(productRepository));
    Get.lazyPut(() => FilterProduct());

    Get.lazyPut<HomeController>(() => HomeController(
          filterProductUC: Get.find(),
          addProductUC: Get.find(),
          removeProductUC: Get.find(),
          editProductUC: Get.find(),
          getProductsUC: Get.find(),
        ));
  }
}