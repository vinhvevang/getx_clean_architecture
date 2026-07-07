import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/account_page.dart';
import 'package:getx_clean_archi/features/product/presentation/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavController>();

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navController.currentTabIndex.value,
          children: const [
            HomePage(), // tab 0
            AccountPage(), // tab 1
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navController.currentTabIndex.value,
          onTap: navController.changeTab,
          selectedItemColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
          ],
        ),
      ),
    );
  }
}
