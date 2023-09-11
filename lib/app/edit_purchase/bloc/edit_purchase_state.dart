part of 'edit_purchase_bloc.dart';

enum EditPurchaseStatus {
  initial,
  loading,
  success,
  failure,
}

class EditPurchaseState extends Equatable {
  const EditPurchaseState({
    required this.total,
    this.status = EditPurchaseStatus.initial,
    this.label = '',
    this.supermarket,
    this.products = const [],
    this.initialPurchase,
  });

  final EditPurchaseStatus status;
  final String label;
  final Supermarket? supermarket;
  final List<Product> products;
  final Purchase? initialPurchase;
  final double total;

  bool get isNewPurchase => initialPurchase == null;

  EditPurchaseState copyWith({
    EditPurchaseStatus? status,
    String? label,
    Supermarket? supermarket,
    List<Product>? products,
    double? total,
  }) {
    return EditPurchaseState(
      initialPurchase: initialPurchase,
      status: status ?? this.status,
      label: label ?? this.label,
      supermarket: supermarket ?? this.supermarket,
      products: products ?? this.products,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
        label,
        supermarket,
        products,
        status,
        total,
      ];
}
