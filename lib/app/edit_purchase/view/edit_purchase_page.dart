import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:purchases_repository/purchases_repository.dart';
import 'package:shopping_tracker/app/edit_product/view/edit_product_page.dart';
import 'package:shopping_tracker/app/edit_purchase/bloc/edit_purchase_bloc.dart';
import 'package:shopping_tracker/app/edit_purchase/widgets/product_tile.dart';
import 'package:shopping_tracker/app/widgets/pop_ups/on_back_alert_pop_up.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class EditPurchasePage extends StatelessWidget {
  const EditPurchasePage({super.key});

  static Route<void> route({Purchase? initialPurchase}) {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditPurchaseBloc(
          initialPurchase: initialPurchase,
          purchasesRepository: context.read<PurchasesRepository>(),
        ),
        child: const EditPurchasePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPurchaseBloc, EditPurchaseState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditPurchaseStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditPurchaseView(),
    );
  }
}

class EditPurchaseView extends StatelessWidget {
  const EditPurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<EditPurchaseBloc, EditPurchaseState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () async {
                var userChoice = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (ctx) => const OnBackAlertPopUp(),
                );
                if (userChoice ?? false) {
                  /* cannot use !context.mounted because that was 
                  implemented in 3.7.0 and this project is made in 3.3.6*/
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              child: const BackButtonIcon(),
            ),
            title: Text(
              state.isNewPurchase
                  ? l10n.newPurchaseTitle
                  : l10n.editPurchaseTitle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  initialValue: state.initialPurchase?.label,
                  onChanged: (value) {
                    context
                        .read<EditPurchaseBloc>()
                        .add(EditPurchaseNameChanged(name: value));
                  },
                  decoration: InputDecoration(
                    hintText: l10n.editPurchaseTitleHint,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.redAccent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const _AddSupermarketCard(),
                const SizedBox(
                  height: 5,
                ),
                const Flexible(
                  child: _ProductsList(),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 20,
                      child: TextFormField(
                        key: Key(
                          state.total.toString(),
                        ),
                        initialValue:
                            state.total.toStringAsFixed(2).replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                                ),
                        onChanged: (value) {
                          context
                              .read<EditPurchaseBloc>()
                              .add(EditPurchaseNameChanged(name: value));
                        },
                        decoration: InputDecoration(
                          hintText: l10n.editPurchaseTitleHint,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.redAccent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: (MediaQuery.of(context).size.width / 2) - 20,
                      child: CupertinoButton.filled(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        padding: const EdgeInsets.all(2),
                        onPressed: () {},
                        child: const Text('Aplicar Descuento'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                child: const Text('Save'),
                onPressed: () {
                  context.read<EditPurchaseBloc>().add(
                        const EditPurchaseSubmitRequest(),
                      );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddSupermarketCard extends StatelessWidget {
  const _AddSupermarketCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text('Supermarket'),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Name'),
                      Text('Address'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 32,
              width: 32,
              child: FloatingActionButton(
                heroTag: 'addSupermarketFloatingButton',
                elevation: 0,
                onPressed: () {},
                child: const Icon(
                  Icons.add,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 15),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.amber,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: BlocBuilder<EditPurchaseBloc, EditPurchaseState>(
            builder: (context, state) {
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    EditProductPage.route(
                      editPurchaseBloc: context.read<EditPurchaseBloc>(),
                      initialProduct: state.products[index],
                    ),
                  ),
                  child: ProductTile(
                    imagePath: state.products[index].imagePath,
                    title: state.products[index].name,
                    price: state.products[index].price,
                    quantity: state.products[index].quantity,
                    isPreSaved: state.products[index].isPreSaved!,
                  ),
                ),
                itemCount: state.products.length,
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            height: 32,
            width: 32,
            child: FloatingActionButton(
              heroTag: 'addProductFloatingButton',
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(
                  EditProductPage.route(
                    editPurchaseBloc: context.read<EditPurchaseBloc>(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
