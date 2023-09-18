import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:purchases_api/purchases_api.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  EditProductBloc({
    Product? initialProduct,
  }) : super(
          EditProductState(
            initialProduct: initialProduct,
            name: initialProduct?.name ?? '',
            price: initialProduct?.price ?? 0.00,
            isPreSaved: initialProduct?.isPreSaved ?? false,
            imagePath: initialProduct?.imagePath,
            quantity: initialProduct?.quantity ?? 1,
            total: (initialProduct?.quantity ?? 1) *
                (initialProduct?.price ?? 0.00),
          ),
        ) {
    on<EditProductNameChanged>(onEditProductTitleChanged);
    on<EditProductPriceChanged>(onEditProductPriceChanged);
    on<EditProductPhotoChanged>(onEditProductPhotoChanged);
    on<EditProductQuantityChanged>(onEditProductQuantityChanged);
    on<EditProductPreregisteredChecBoxChanged>(
      onEditProductPreregisteredChecBoxChanged,
    );
    on<EditProductSubmit>(onEditProductSubmit);
    on<EditProductShowDoneButton>(onEditProductShowDoneButton);
  }

  void onEditProductTitleChanged(
    EditProductNameChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(name: event.name),
    );
  }

  void onEditProductPriceChanged(
    EditProductPriceChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(
        price: event.price,
        total: event.price * state.quantity,
      ),
    );
  }

  void onEditProductQuantityChanged(
    EditProductQuantityChanged event,
    Emitter<EditProductState> emit,
  ) {
    if (event.increase) {
      emit(
        state.copyWith(
          quantity: state.quantity + 1,
          total: state.price * (state.quantity + 1),
        ),
      );
    } else {
      if (state.quantity >= 2) {
        emit(
          state.copyWith(
            quantity: state.quantity - 1,
            total: state.price * (state.quantity - 1),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProductStatus.quantityUnderZero,
          ),
        );
        emit(
          state.copyWith(
            status: ProductStatus.initial,
          ),
        );
      }
    }
  }

  Future<void> onEditProductPhotoChanged(
    EditProductPhotoChanged event,
    Emitter<EditProductState> emit,
  ) async {
    if (event.removePhoto) {
      emit(
        state.copyWith(
          imagePath: () => null,
          status: ProductStatus.loading,
        ),
      );
      return;
    }
    File? imagePicked;
    final picker = ImagePicker();
    // Capture a photo.
    final photo = await picker.pickImage(source: event.source);
    if (photo != null) {
      imagePicked = File(photo.path);
      final fileName = path.basename(imagePicked.path);
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final copiedImage = await imagePicked.copy('${appDir.path}/$fileName');
      emit(
        state.copyWith(
          imagePath: () => copiedImage.path,
        ),
      );
    }
  }

  void onEditProductPreregisteredChecBoxChanged(
    EditProductPreregisteredChecBoxChanged event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(isPreSaved: !state.isPreSaved),
    );
  }

  void onEditProductSubmit(
    EditProductSubmit event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(status: ProductStatus.success),
    );
  }

  void onEditProductShowDoneButton(
    EditProductShowDoneButton event,
    Emitter<EditProductState> emit,
  ) {
    emit(
      state.copyWith(
        showDoneButton: event.showDoneButton,
      ),
    );
  }
}
