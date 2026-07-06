import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:getx_clean_archi/features/auth/bindings/login_bindings.dart';
import 'package:getx_clean_archi/features/auth/bindings/logout_bindings.dart';
import 'package:getx_clean_archi/features/auth/bindings/nav_bindings.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/login_page.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/main_page.dart';
import 'package:getx_clean_archi/features/product/bindings/product_bindings.dart';
import 'package:getx_clean_archi/features/product/presentation/pages/home_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: LoginBinding(),
        ),

        GetPage(
          name: '/home',
          page: () => HomePage(), // nhớ tạo
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/main',
          page: () => MainPage(),
          binding: NavBinding(),
          // IndexedStack trong MainPage build HomePage() ngay lập tức (tab 0),
          // nên HomeController phải sẵn sàng ngay khi vào '/main', không phải
          // chờ điều hướng riêng tới '/home'. Gắn thêm ở đây thay vì gộp code
          // vào NavBinding để mỗi binding vẫn chỉ lo đúng phần việc của nó.
          bindings: [HomeBinding(), LogoutBinding()],
        ),
      ],
    ),
  );
}
