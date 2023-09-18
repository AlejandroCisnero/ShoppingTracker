import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/edit_purchase/view/edit_purchase_page.dart';
import 'package:shopping_tracker/app/purchases_overview/overview_bloc/purchases_bloc.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class PurchasesOverviewPage extends StatelessWidget {
  const PurchasesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchasesBloc(
        purchasesRepository: context.read<PurchasesRepository>(),
      )..add(const PurchasesOverviewSubscriptionRequested()),
      child: const PurchasesOverviewView(),
    );
  }
}

class PurchasesOverviewView extends StatelessWidget {
  const PurchasesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.14),
      colorScheme.surface,
    );
    final l10n = context.l10n;
    final status = context.read<PurchasesBloc>().state.status;
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            l10n.counterAppBarTitle,
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).push(EditPurchasePage.route());
            },
            child: status == PurchasesOverviewStatus.loading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : const Icon(
                    Icons.create_outlined,
                  ),
          ),
        ),
        child: const PurchasesOverviewViewScaffoldBody(),
      );
    } else {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            l10n.counterAppBarTitle,
            style: TextStyle(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        body: const PurchasesOverviewViewScaffoldBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<PurchasesBloc, PurchasesState>(
          builder: (context, state) {
            return FloatingActionButton(
              key: const Key('purchasesview_add_floatingActionButton'),
              backgroundColor: colorScheme.tertiaryContainer,
              foregroundColor: colorScheme.onTertiaryContainer,
              onPressed: () {
                Navigator.of(context).push(EditPurchasePage.route());
              },
              child: state.status == PurchasesOverviewStatus.loading
                  ? SizedBox(
                      height: 26,
                      width: 26,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.add,
                      color: colorScheme.onPrimary,
                    ),
            );
          },
        ),
      );
    }
  }
}

class PurchasesOverviewViewScaffoldBody extends StatelessWidget {
  const PurchasesOverviewViewScaffoldBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PurchasesBloc, PurchasesState>(
      builder: (context, state) {
        if (state.purchases.isEmpty) {
          if (state.status == PurchasesOverviewStatus.loading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state.status != PurchasesOverviewStatus.success) {
            return const SizedBox.expand();
          } else {
            return Center(
              child: Text(l10n.noPurchasesText),
            );
          }
        }

        return ListView.builder(
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                EditPurchasePage.route(
                  initialPurchase: state.purchases[index],
                ),
              );
            },
            child: Material(
              child: ListTile(
                title: Text(state.purchases[index].label),
                subtitle: Text(
                  'Expent amount: ${state.purchases[index].getSpentAmount().toStringAsFixed(2).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      )}',
                ),
              ),
            ),
          ),
          itemCount: state.purchases.length,
        );
      },
    );
  }
}
