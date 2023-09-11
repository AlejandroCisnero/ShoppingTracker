part of 'edit_purchase_bloc.dart';

abstract class EditPurchaseEvent extends Equatable {
  const EditPurchaseEvent();

  @override
  List<Object?> get props => [];
}

class PurchaseSupermarketChanged extends EditPurchaseEvent {
  const PurchaseSupermarketChanged({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class EditPurchaseNameChanged extends EditPurchaseEvent {
  const EditPurchaseNameChanged({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class AddPurchaseProduct extends EditPurchaseEvent {
  const AddPurchaseProduct({
    required this.product,
  });

  final Product product;

  @override
  List<Object?> get props => [
        product,
      ];
}

class EditPurchaseSubmitRequest extends EditPurchaseEvent {
  const EditPurchaseSubmitRequest();

  @override
  List<Object?> get props => [];
}
