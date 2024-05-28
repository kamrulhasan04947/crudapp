class ProductModel{
  final String id, productName, productCode , imageUrl;
  final double unitPrice, totalPrice;
  final int productQuantity;

  const ProductModel({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.productQuantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.imageUrl,
  });
}