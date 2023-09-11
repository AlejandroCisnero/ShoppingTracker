part of 'purchases_bloc.dart';

abstract class PurchasesEvent extends Equatable {
  const PurchasesEvent();

  @override
  List<Object?> get props => [];
}

class PurchasesOverviewSubscriptionRequested extends PurchasesEvent {
  const PurchasesOverviewSubscriptionRequested();
}

class PurchasesOverviewDeleted extends PurchasesEvent {
  const PurchasesOverviewDeleted({required this.purchase});

  final Purchase purchase;

  @override
  List<Object?> get props => [purchase];
}

class PurchasesOverviewChangeFilterChanged extends PurchasesEvent {
  const PurchasesOverviewChangeFilterChanged({required this.filterType});

  final PurchasesFilterView filterType;

  @override
  List<Object?> get props => [filterType];
}
