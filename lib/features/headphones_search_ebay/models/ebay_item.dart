class EbayItem {
  final String title;
  final double price;
  final String currency;

  EbayItem({required this.title, required this.price, required this.currency});

  factory EbayItem.fromJson(Map<String, dynamic> json) {
    return EbayItem(
      title: json['title'] as String,
      price: double.parse(json['price']['value']),
      currency: json['price']['currency'] as String,
    );
  }

  String get displayInfo {
    return '$title - $price $currency';
  }
}
