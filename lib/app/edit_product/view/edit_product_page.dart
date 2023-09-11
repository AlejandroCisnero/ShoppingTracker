import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_api/purchases_api.dart';
import 'package:shopping_tracker/app/edit_product/bloc/edit_product_bloc.dart';
import 'package:shopping_tracker/app/edit_purchase/bloc/edit_purchase_bloc.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  static Route<void> route({
    required EditPurchaseBloc editPurchaseBloc,
    Product? initialProduct,
  }) {
    return CupertinoPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => EditProductBloc(
                initialProduct: initialProduct,
              ),
              child: const EditProductPage(),
            ),
            BlocProvider.value(value: editPurchaseBloc)
          ],
          child: const EditProductPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    Future<void> onImageTap() async {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => CupertinoActionSheet(
          title: Text(l10n.productImageActionTitle),
          message: Text(l10n.productImageActionMessage),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<EditProductBloc>().add(
                      const EditProductPhotoChanged(
                        source: ImageSource.gallery,
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: Text(l10n.pickAPhotoOption),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<EditProductBloc>().add(
                      const EditProductPhotoChanged(),
                    );
                Navigator.of(context).pop();
              },
              child: Text(l10n.takeAPhotoOption),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                context.read<EditProductBloc>().add(
                      const EditProductPhotoChanged(removePhoto: true),
                    );
                Navigator.of(context).pop();
              },
              child: Text(l10n.removeAPhotoOption),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelOption),
            ),
          ],
        ),
      );
    }

    return BlocListener<EditProductBloc, EditProductState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ProductStatus.initial:
            // TODO: Handle this case.
            break;
          case ProductStatus.loading:
            // TODO: Handle this case.
            break;
          case ProductStatus.success:
            Navigator.of(context).pop();
            break;
          case ProductStatus.failure:
            // TODO: Handle this case.
            break;
          case ProductStatus.quantityUnderZero:
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'You cannot set a negative quantity',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.deepOrange[700],
                ),
              );
            break;
        }
      },
      child: BlocBuilder<EditProductBloc, EditProductState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.read<EditProductBloc>().state.isNewProduct
                    ? l10n.newProductPageTitle
                    : l10n.editProductPageTitle,
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: state.name,
                          onChanged: (value) {
                            context.read<EditProductBloc>().add(
                                  EditProductNameChanged(
                                    name: value,
                                  ),
                                );
                          },
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: l10n.productNameFieldHint,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  15,
                                ),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (constraints.maxWidth / 3) - 20,
                                child: TextFormField(
                                  initialValue: state.initialProduct?.price
                                      .toStringAsFixed(2),
                                  onChanged: (value) {
                                    context.read<EditProductBloc>().add(
                                          EditProductPriceChanged(
                                            price: (num.tryParse(value) ?? 0.00)
                                                .toDouble(),
                                          ),
                                        );
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: l10n.productPriceFieldHint,
                                    hintStyle: const TextStyle(fontSize: 12),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
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
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.redAccent,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 65,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                width: (constraints.maxWidth / 3) - 20,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Qty'),
                                    Text(state.quantity.toString()),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: (constraints.maxWidth / 8) - 20,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<EditProductBloc>()
                                                    .add(
                                                      const EditProductQuantityChanged(
                                                        increase: true,
                                                      ),
                                                    );
                                              },
                                              child: const Icon(
                                                Icons.arrow_drop_up_rounded,
                                              ),
                                            ),
                                            const Divider(
                                              height: 0.5,
                                              indent: 5,
                                              endIndent: 5,
                                              color: Colors.grey,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<EditProductBloc>()
                                                    .add(
                                                      const EditProductQuantityChanged(
                                                        increase: false,
                                                      ),
                                                    );
                                              },
                                              child: const Icon(
                                                Icons.arrow_drop_down_rounded,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: (constraints.maxWidth / 3) - 20,
                                child: TextFormField(
                                  key: Key(state.total.toString()),
                                  enabled: false,
                                  initialValue: state.total.toStringAsFixed(2),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: l10n.productPriceFieldHint,
                                    hintStyle: const TextStyle(fontSize: 12),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey,
                                      ),
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
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors.redAccent,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: GestureDetector(
                            onTap: onImageTap,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(
                                  color: Colors.amber,
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(microseconds: 200),
                                child: state.imagePath != null &&
                                        state.imagePath!.isNotEmpty
                                    ? Image.file(
                                        File(state.imagePath!),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                    : const Icon(
                                        Icons.camera_rounded,
                                        size: 36,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 46,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              context.read<EditProductBloc>().add(
                                    const EditProductPreregisteredChecBoxChanged(),
                                  );
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: state.isPreSaved,
                                  onChanged: (value) {},
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                ),
                                Text(l10n.productMarkAsPreSaved),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(20),
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  context.read<EditPurchaseBloc>().add(
                        AddPurchaseProduct(
                          product: (state.initialProduct ??
                                  Product(
                                    name: '',
                                    price: 0,
                                    quantity: 1,
                                  ))
                              .copyWith(
                            name: state.name,
                            price: state.price,
                            imagePath: state.imagePath,
                            isPreSaved: state.isPreSaved,
                            quantity: state.quantity,
                          ),
                        ),
                      );
                  context
                      .read<EditProductBloc>()
                      .add(const EditProductSubmit());
                },
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  minimumSize: MaterialStatePropertyAll<Size>(
                    Size(double.infinity, 40),
                  ),
                ),
                child: Text(l10n.submitButtonText),
              ),
            ),
          );
        },
      ),
    );
  }
}