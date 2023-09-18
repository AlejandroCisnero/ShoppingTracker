part of 'edit_product_bloc.dart';

class EditProductEvent extends Equatable {
  const EditProductEvent();

  @override
  List<Object?> get props => [];
}

class EditProductLoad extends EditProductEvent {
  const EditProductLoad({
    this.initialProduct,
  });

  final Product? initialProduct;

  @override
  List<Object?> get props => [initialProduct];
}

class EditProductNameChanged extends EditProductEvent {
  const EditProductNameChanged({
    required this.name,
  });
  final String name;

  @override
  List<Object?> get props => [name];
}

class EditProductPriceChanged extends EditProductEvent {
  const EditProductPriceChanged({
    required this.price,
  });
  final double price;

  @override
  List<Object?> get props => [price];
}

class EditProductPhotoChanged extends EditProductEvent {
  const EditProductPhotoChanged({
    this.source = ImageSource.camera,
    this.removePhoto = false,
  });

  final ImageSource source;
  final bool removePhoto;

  @override
  List<Object?> get props => [source, removePhoto];
}

class EditProductPreregisteredChecBoxChanged extends EditProductEvent {
  const EditProductPreregisteredChecBoxChanged();
}

class EditProductSubmit extends EditProductEvent {
  const EditProductSubmit();
}

class EditProductQuantityChanged extends EditProductEvent {
  const EditProductQuantityChanged({
    required this.increase,
  });

  final bool increase;

  @override
  List<Object?> get props => [increase];
}

class EditProductShowDoneButton extends EditProductEvent {
  const EditProductShowDoneButton({required this.showDoneButton});

  final bool showDoneButton;
  @override
  List<Object?> get props => [showDoneButton];
}
