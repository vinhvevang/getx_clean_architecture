import 'package:intl/intl.dart';

/// Formatter dùng chung cho app (giá tiền, số lượng, số lớn...)
class AppFormatter {
  AppFormatter._();

  /// =========================
  /// FORMAT TIỀN TỆ (VND)
  /// =========================
  /// Ví dụ:
  /// 1000 -> 1.000 đ
  /// 1000000 -> 1.000.000 đ
  static String currency(num value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(value)} đ';
  }

  /// =========================
  /// FORMAT SỐ THƯỜNG
  /// =========================
  /// Ví dụ:
  /// 1000 -> 1.000
  static String number(num value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(value);
  }

  /// =========================
  /// FORMAT NGẮN (Shopee style)
  /// =========================
  /// 1200 -> 1.2k
  /// 1500000 -> 1.5M
  /// 2000000000 -> 2B
  static String compact(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }

  /// =========================
  /// FORMAT GIÁ SALE
  /// =========================
  /// original: 100000
  /// sale: 80000
  /// -> -20%
  static String discountPercent({required num original, required num sale}) {
    if (original == 0) return '';
    final percent = ((original - sale) / original * 100).round();
    return '-$percent%';
  }

  /// =========================
  /// SAFE PARSE (tránh lỗi số lớn)
  /// =========================
  static int parseInt(dynamic value) {
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.parse(value);
      return 0;
    } catch (_) {
      return 0;
    }
  }

  static double parseDouble(dynamic value) {
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);
      return 0.0;
    } catch (_) {
      return 0.0;
    }
  }
}
