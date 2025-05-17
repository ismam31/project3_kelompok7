class CartItemModel {
  final String id;
  final String name;
  final int price;
  final String image;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  // Untuk menambah jumlah item
  void incrementQuantity() {
    quantity++;
  }

  // Untuk mengurangi jumlah item
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  // Hitung total harga per item
  int get totalPrice => price * quantity;
}