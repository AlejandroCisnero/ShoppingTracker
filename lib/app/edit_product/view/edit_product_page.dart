import 'dart:io';
import 'dart:math';

import 'package:easy_image_viewer/easy_image_viewer.dart';
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
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.14),
      colorScheme.surface,
    );

    return BlocListener<EditProductBloc, EditProductState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ProductStatus.success:
            Navigator.of(context).pop();
            break;
          // ignore: no_default_cases
          default:
            return;
        }
      },
      child: BlocBuilder<EditProductBloc, EditProductState>(
        builder: (context, state) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                context.read<EditProductBloc>().state.isNewProduct
                    ? l10n.newProductPageTitle
                    : l10n.editProductPageTitle,
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: colorScheme.onBackground,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      key: const Key('done_button_text'),
                      'Save',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navActionTextStyle,
                    ),
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
                                imagePath: () => state.imagePath,
                                isPreSaved: state.isPreSaved,
                                quantity: state.quantity,
                              ),
                            ),
                          );
                      context
                          .read<EditProductBloc>()
                          .add(const EditProductSubmit());
                    },
                  ),
                  BlocBuilder<EditProductBloc, EditProductState>(
                    buildWhen: (previous, current) {
                      return previous.showDoneButton != current.showDoneButton;
                    },
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        reverseDuration: const Duration(milliseconds: 100),
                        child: state.showDoneButton
                            ? CupertinoButton(
                                key: const Key(
                                  'edit_product_page_appbar_done_button',
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                onPressed: () {
                                  context.read<EditProductBloc>().add(
                                        const EditProductShowDoneButton(
                                          showDoneButton: false,
                                        ),
                                      );
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text(
                                  key: const Key('done_button_text'),
                                  'Done',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .navActionTextStyle,
                                ),
                              )
                            : const Center(
                                child: SizedBox.shrink(),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
            child: const Material(
              child: EditProductPageScaffoldBody(),
            ),
          );
        },
      ),
    );
  }
}

class EditProductPageScaffoldBody extends StatelessWidget {
  const EditProductPageScaffoldBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.read<EditProductBloc>().state;

    Future<void> onImageTap() async {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => CupertinoActionSheet(
          title: Text(l10n.productImageActionTitle),
          message: Text(l10n.productImageActionMessage),
          actions: <CupertinoActionSheetAction>[
            if (state.imagePath != null)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  showImageViewer(
                    context,
                    FileImage(
                      File(state.imagePath!),
                    ),
                    doubleTapZoomable: true,
                  );
                },
                child: const Text('View Image'),
              ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<EditProductBloc>().add(
                      const EditProductPhotoChanged(
                        source: ImageSource.gallery,
                      ),
                    );
              },
              child: Text(l10n.pickAPhotoOption),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<EditProductBloc>().add(
                      const EditProductPhotoChanged(),
                    );
              },
              child: Text(l10n.takeAPhotoOption),
            ),
            if (state.imagePath != null)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<EditProductBloc>().add(
                        const EditProductPhotoChanged(removePhoto: true),
                      );
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

    void onQuantityDecreased() {
      if (state.quantity - 1 <= 0) {
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
      } else {
        context.read<EditProductBloc>().add(
              const EditProductQuantityChanged(
                increase: false,
              ),
            );
      }
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: TextFormField(
                      initialValue: state.name,
                      onTap: () => context.read<EditProductBloc>().add(
                            const EditProductShowDoneButton(
                              showDoneButton: true,
                            ),
                          ),
                      onChanged: (value) {
                        context.read<EditProductBloc>().add(
                              EditProductNameChanged(
                                name: value,
                              ),
                            );
                      },
                      onFieldSubmitted: (value) =>
                          context.read<EditProductBloc>().add(
                                const EditProductShowDoneButton(
                                  showDoneButton: false,
                                ),
                              ),
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
                            initialValue:
                                state.initialProduct?.price.toStringAsFixed(2),
                            onTap: () => context.read<EditProductBloc>().add(
                                  const EditProductShowDoneButton(
                                    showDoneButton: true,
                                  ),
                                ),
                            onFieldSubmitted: (value) =>
                                context.read<EditProductBloc>().add(
                                      const EditProductShowDoneButton(
                                        showDoneButton: false,
                                      ),
                                    ),
                            onChanged: (value) {
                              context.read<EditProductBloc>().add(
                                    EditProductPriceChanged(
                                      price: (num.tryParse(value) ?? 0.00)
                                          .toDouble(),
                                    ),
                                  );
                            },
                            keyboardType: const TextInputType.numberWithOptions(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.read<EditProductBloc>().add(
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
                                        onTap: onQuantityDecreased,
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
                          duration: const Duration(milliseconds: 500),
                          reverseDuration: const Duration(
                            milliseconds: 500,
                          ),
                          child: state.imagePath != null
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
    );
  }
}
