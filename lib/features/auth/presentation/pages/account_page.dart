
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.find<LoginController>().logout(),
          child: const Text('Đăng xuất'),
        ),
      ),
    );
  }
}
