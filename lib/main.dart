import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_clean_archi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:getx_clean_archi/features/auth/domain/usecases/login.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/login_page.dart';

import 'package:getx_clean_archi/features/product/data/repositories/product_repository_impl.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/add_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/edit_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/filtered_product.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/get_products.dart';
import 'package:getx_clean_archi/features/product/domain/usecases/remove_product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

void main() {
final authRepo = AuthRepositoryImpl();
final productRepo = ProductRepositoryImpl();

/// ================= USE CASES =================
final loginUC = Login(authRepo);

final addProductUC = AddProduct(productRepo);
final removeProductUC = RemoveProduct(productRepo);
final editProductUC = EditProduct(productRepo);
final getProductsUC = GetProducts(productRepo);
final filterProductUC = FilterProduct();

/// ================= CONTROLLERS =================
Get.put(LoginController(loginUC));
Get.put(NavController());

Get.put(
HomeController(
  filterProductUC:  filterProductUC,
addProductUC: addProductUC,
removeProductUC: removeProductUC,
editProductUC: editProductUC,
getProductsUC: getProductsUC,
),
);

/// ================= APP =================
runApp(
GetMaterialApp(
debugShowCheckedModeBanner: false,
home: LoginPage(),
),
);
}
