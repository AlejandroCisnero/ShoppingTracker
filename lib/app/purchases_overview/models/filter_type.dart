import 'package:purchases_api/purchases_api.dart';

enum PurchasesFilterView {
  mostRecent,
  oldest,
  mostExpensive,
  lessExpensive,
}

extension PurchasesFilterViewX on PurchasesFilterView {
  Iterable<Purchase> applyMostRecent(List<Purchase> purchases) {
    purchases.sort(
      (a, b) {
        return a.createdAt.compareTo(b.createdAt);
      },
    );
    return purchases;
  }

  Iterable<Purchase> applyOldest(List<Purchase> purchases) {
    purchases.sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );
    return purchases;
  }

  Iterable<Purchase> applyMostExpensive(
    List<Purchase> purchases,
  ) {
    purchases.sort(
      (a, b) {
        var aSpentAmount = 0.00;
        var bSpentAmount = 0.00;

        for (final product in a.products) {
          aSpentAmount += product.price;
        }

        for (final product in b.products) {
          bSpentAmount += product.price;
        }

        return aSpentAmount.compareTo(bSpentAmount);
      },
    );

    return purchases;
  }

  Iterable<Purchase> applyLessExpensive(
    List<Purchase> purchases,
  ) {
    purchases.sort(
      (a, b) {
        var aSpentAmount = 0.00;
        var bSpentAmount = 0.00;

        for (final product in a.products) {
          aSpentAmount += product.price;
        }

        for (final product in b.products) {
          bSpentAmount += product.price;
        }

        return bSpentAmount.compareTo(aSpentAmount);
      },
    );

    return purchases;
  }
}
