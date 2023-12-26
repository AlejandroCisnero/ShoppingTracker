import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/edit_purchase/view/edit_purchase_page.dart';
import 'package:shopping_tracker/app/purchases_overview/overview_bloc/purchases_bloc.dart';
import 'package:shopping_tracker/app/settings_page/settings_page.dart';
import 'package:shopping_tracker/app/ui/theme/bloc/theme_bloc.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        title: Text(
          l10n.counterAppBarTitle,
          style: TextStyle(
            color: colorScheme.onBackground,
          ),
        ),
      ),
      drawer: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(
                  SettingsPage.route(),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings'),
                  Icon(Icons.settings),
                ],
              ),
            )
          ],
        ),
      ),
      body: const PurchasesOverviewViewScaffoldBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          return FloatingActionButton(
            key: const Key('purchasesview_add_floatingActionButton'),
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            onPressed: () {
              Navigator.of(context).push(EditPurchasePage.route());
            },
            child: state.status == PurchasesOverviewStatus.loading
                ? SizedBox(
                    height: 26,
                    width: 26,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimaryContainer,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Icon(
                    Icons.add,
                    color: colorScheme.onPrimaryContainer,
                  ),
          );
        },
      ),
    );
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
