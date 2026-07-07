import 'package:flutter/services.dart';

/// Bộ lọc ký tự dùng chung cho các ô chỉ nhận số dương trong app.
class AppInputFormatters {
  AppInputFormatters._();

  /// Chỉ cho nhập chữ số 0-9 (số nguyên dương) — dùng cho số lượng, mã số thuế...
  static final positiveInteger = FilteringTextInputFormatter.digitsOnly;

  /// Cho nhập số thập phân dương: chữ số + tối đa một dấu chấm, không dấu trừ.
  /// Dùng cho các ô giá.
  static final positiveDecimal = _PositiveDecimalInputFormatter();
}

class _PositiveDecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    if (RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text)) {
      return newValue;
    }
    // Ký tự vừa gõ (dấu trừ, chữ, dấu chấm thứ 2...) không hợp lệ -> giữ nguyên
    // giá trị cũ, coi như bỏ qua ký tự đó.
    return oldValue;
  }
}
