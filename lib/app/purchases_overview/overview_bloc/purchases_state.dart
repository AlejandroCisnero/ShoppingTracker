part of 'purchases_bloc.dart';

enum PurchasesOverviewStatus {
  initial,
  loading,
  success,
  failure,
}

class PurchasesState extends Equatable {
  const PurchasesState({
    this.status = PurchasesOverviewStatus.initial,
    this.purchases = const [],
    this.filterView = PurchasesFilterView.mostRecent,
  });

  final PurchasesOverviewStatus status;
  final List<Purchase> purchases;
  final PurchasesFilterView filterView;

  PurchasesState copyWith({
    PurchasesOverviewStatus? status,
    List<Purchase>? purchases,
    PurchasesFilterView? filterView,
  }) {
    return PurchasesState(
      status: status ?? this.status,
      purchases: purchases ?? this.purchases,
      filterView: filterView ?? this.filterView,
    );
  }

  @override
  List<Object?> get props => [status, purchases, filterView];
}
