enum Category {
  all,
  shoes,
  clothes,
  electronics,
}

extension CategoryExt on Category {
  String get nameVi {
    switch (this) {
      case Category.all:
        return 'Tất cả';
      case Category.shoes:
        return 'Giày';
      case Category.clothes:
        return 'Quần áo';
      case Category.electronics:
        return 'Điện tử';
    }
  }
}