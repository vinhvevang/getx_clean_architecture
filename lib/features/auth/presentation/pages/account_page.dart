import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/confirm_dialog.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/logout_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Future<void> _confirmLogout() async {
    final confirmed = await showConfirmDialog(
      title: 'Đăng xuất',
      message: 'Bạn có chắc muốn đăng xuất không?',
      confirmLabel: 'Đăng xuất',
      isDestructive: true,
    );

    if (confirmed) {
      Get.find<LogoutController>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.border,
              child: Icon(Icons.person, size: 44, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tài khoản',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _confirmLogout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
