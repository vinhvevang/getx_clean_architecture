import 'package:flutter/material.dart';

/// Bộ màu dùng chung cho cả app, phong cách giống Shopee (cam chủ đạo).
///
/// Dùng [AppColors.primary] thay vì hard-code mã màu rải rác nhiều nơi,
/// để sau này đổi màu thương hiệu chỉ cần sửa một chỗ.
class AppColors {
  AppColors._();

  /// Màu cam thương hiệu (tương tự Shopee). 🔥
  static const Color primary = Color(0xFFEE4D2D);

  /// Cam đậm hơn, dùng cho trạng thái pressed/gradient. 🔥
  static const Color primaryDark = Color(0xFFD73211);

  /// Nền xám nhạt cho toàn màn hình (giống nền app Shopee). 🔥
  static const Color background = Color(0xFFF5F5F5);

  /// Viền/khung mảnh cho card, ô ảnh placeholder.
  static const Color border = Color(0xFFEFEFEF);

  /// Chữ phụ (mô tả, số lượng tồn kho...).
  static const Color textSecondary = Color(0xFF757575);
}
