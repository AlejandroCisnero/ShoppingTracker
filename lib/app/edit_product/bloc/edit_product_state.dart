part of 'edit_product_bloc.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
  quantityUnderZero,
}

class EditProductState extends Equatable {
  const EditProductState({
    this.status = ProductStatus.initial,
    this.initialProduct,
    this.name = '',
    this.price = 0.00,
    this.isPreSaved = false,
    this.imagePath,
    this.quantity = 1,
    this.total = 0,
  });

  final ProductStatus status;
  final Product? initialProduct;
  final String name;
  final double price;
  final String? imagePath;
  final bool isPreSaved;
  final int quantity;
  final double total;

  bool get isNewProduct => initialProduct == null;

  EditProductState copyWith({
    ProductStatus? status,
    Product? initialProduct,
    String? name,
    double? price,
    String? imagePath,
    bool? isPreSaved,
    int? quantity,
    double? total,
  }) {
    return EditProductState(
      status: status ?? this.status,
      initialProduct: initialProduct ?? this.initialProduct,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      isPreSaved: isPreSaved ?? this.isPreSaved,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialProduct,
        name,
        price,
        imagePath,
        isPreSaved,
        quantity,
        total,
      ];
}
