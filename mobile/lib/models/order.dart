class FoodOrder {
  final int id;
  final int customerId;
  final int restaurantId;
  final int? riderId;
  final String status;
  final String deliveryAddress;
  final double totalAmount;

  FoodOrder({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.riderId,
    required this.status,
    required this.deliveryAddress,
    required this.totalAmount,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'],
      customerId: json['customerId'],
      restaurantId: json['restaurantId'],
      riderId: json['riderId'],
      status: json['status'] ?? 'PLACED',
      deliveryAddress: json['deliveryAddress'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    );
  }
}
