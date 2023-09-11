import 'dart:io';

import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.quantity,
    required this.isPreSaved,
  });

  final String? imagePath;
  final String title;
  final double price;
  final int quantity;
  final bool isPreSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              backgroundImage: imagePath != null && imagePath!.isNotEmpty
                  ? FileImage(
                      File(imagePath!),
                    )
                  : null,
            ),
          ),
          Expanded(child: Text(title)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              (price * quantity).toStringAsFixed(2).replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},',
                  ),
            ),
          ),
          SizedBox(
            height: 15,
            width: 15,
            child: Checkbox(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              value: isPreSaved,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
