import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:purchases_repository/purchases_repository.dart';

part 'edit_purchase_event.dart';
part 'edit_purchase_state.dart';

class EditPurchaseBloc extends Bloc<EditPurchaseEvent, EditPurchaseState> {
  EditPurchaseBloc({
    required PurchasesRepository purchasesRepository,
    required Purchase? initialPurchase,
  })  : _purchasesRepository = purchasesRepository,
        super(
          EditPurchaseState(
            initialPurchase: initialPurchase,
            label: initialPurchase?.label ?? '',
            supermarket: initialPurchase?.supermarket,
            products: initialPurchase?.products ?? const [],
            total: () {
              var total = 0.00;
              for (final product in initialPurchase?.products ?? <Product>[]) {
                total += product.price * product.quantity;
              }
              return total;
            }.call(),
          ),
        ) {
    on<EditPurchaseNameChanged>(_onEditPurchaseNameChanged);
    on<AddPurchaseProduct>(_onaddPurchaseProduct);
    on<EditPurchaseSubmitRequest>(_onEditPurchaseSubmitRequest);
  }

  final PurchasesRepository _purchasesRepository;

  void _onEditPurchaseNameChanged(
    EditPurchaseNameChanged event,
    Emitter<EditPurchaseState> emit,
  ) {
    emit(state.copyWith(label: event.name));
  }

  void _onaddPurchaseProduct(
    AddPurchaseProduct event,
    Emitter<EditPurchaseState> emit,
  ) {
    final products = [...state.products];
    final productIndex = products.indexWhere(
      (product) => event.product.uuid == product.uuid,
    );
    if (productIndex == -1) {
      products.add(event.product);
    } else {
      products[productIndex] = event.product;
    }
    var total = 0.00;
    for (final product in products) {
      total += product.price * product.quantity;
    }
    emit(
      state.copyWith(
        products: products,
        total: total,
      ),
    );
  }

  Future<void> _onEditPurchaseSubmitRequest(
    EditPurchaseSubmitRequest event,
    Emitter<EditPurchaseState> emit,
  ) async {
    final purchase = (state.initialPurchase ?? Purchase()).copyWith(
      label: state.label,
      cart: state.products,
      supermarket: state.supermarket,
    );
    await _purchasesRepository.savePurchase(
      purchase,
    );
    emit(state.copyWith(status: EditPurchaseStatus.success));
  }
}
