import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/purchases_overview/models/filter_type.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  PurchasesBloc({
    required PurchasesRepository purchasesRepository,
  })  : _purchasesRepository = purchasesRepository,
        super(
          const PurchasesState(),
        ) {
    on<PurchasesOverviewSubscriptionRequested>(
      _onPurchasesSubscriptionRequested,
    );
  }

  final PurchasesRepository _purchasesRepository;

  //Handlers
  Future<void> _onPurchasesSubscriptionRequested(
    PurchasesOverviewSubscriptionRequested event,
    Emitter<PurchasesState> emit,
  ) async {
    emit(
      state.copyWith(status: PurchasesOverviewStatus.loading),
    );
    await Future.delayed(
      const Duration(seconds: 2),
      () {},
    );
    await emit.forEach<List<Purchase>>(
      _purchasesRepository.getPurchases(),
      onData: (data) {
        return state.copyWith(
          status: PurchasesOverviewStatus.success,
          purchases: data,
        );
      },
      onError: (_, __) => state.copyWith(
        status: PurchasesOverviewStatus.failure,
      ),
    );
  }
}
