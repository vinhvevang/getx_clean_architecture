class Product {
  final String name;
  final double price;
  final double quan;
  final String imageUrl;
  final String category; // 👈 NEW

  Product(
    this.name,
    this.price,
    this.quan,
    this.imageUrl,
    this.category,
  );
}