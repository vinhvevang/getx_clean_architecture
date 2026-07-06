import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';

/// Hộp thoại xác nhận dùng chung (xóa sản phẩm, đăng xuất, v.v.)
/// Trả về `true` nếu người dùng bấm nút xác nhận, `false`/`null` nếu hủy
/// hoặc đóng dialog bằng cách khác (bấm ra ngoài, nút back).
Future<bool> showConfirmDialog({
  required String title,
  required String message,
  String confirmLabel = 'Xác nhận',
  String cancelLabel = 'Hủy',
  bool isDestructive = false,
}) async {
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(
            foregroundColor: isDestructive ? AppColors.danger : AppColors.primary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
