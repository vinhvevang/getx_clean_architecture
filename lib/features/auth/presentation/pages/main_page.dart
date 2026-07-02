
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/nav_controller.dart';
import 'package:getx_clean_archi/features/auth/presentation/pages/account_page.dart';
import 'package:getx_clean_archi/features/product/presentation/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: nav.tabIndex.value,
          children: [
            HomePage(),           // tab 0
            const AccountPage(),  // tab 1
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.tabIndex.value,
          onTap: nav.changeTab,
          selectedItemColor: Color(0xFFEE4D2D),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),   label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
          ],
        ),
      ),
    );
  }
}
