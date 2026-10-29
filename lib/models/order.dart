class Order {
  final String id;
  final String buyerId;
  final String artworkId;
  final double amount;
  final DateTime createdAt;

  String status;

  Order({
    required this.id,
    required this.buyerId,
    required this.artworkId,
    required this.amount,
    required this.createdAt,
    this.status = 'Completed',
  });
}