class TicketType {
  int id;
  String name;
  double cost;
  int quantity;
  int sold;
  int scanned;

  TicketType({
    this.id,
    this.name,
    this.cost = 0,
    this.quantity = 0,
    this.sold = 0,
    this.scanned = 0,
  });

  factory TicketType.fromMap(Map<String, dynamic> data) {
    return TicketType(
      id: data['id'],
      name: data['name'],
      cost: data['cost'].toDouble(),
      quantity: data['quantity'],
      sold: data['sold'],
      scanned: data['scanned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': cost.floor(),
      'name': name,
      'cost': cost,
      'quantity': quantity,
      'sold': sold,
      'scanned': scanned
    };
  }

  @override
  String toString() => 'id: $id, name: $name, cost: $cost, '
      'quantity: $quantity, sold: $sold, scanned: $scanned';
}
