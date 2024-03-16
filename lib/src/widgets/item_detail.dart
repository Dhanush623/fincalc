import 'package:finance/src/helper/currency_helper.dart';
import 'package:finance/src/models/card_item.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    super.key,
    required this.item,
  });
  final CardItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.key,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              indianCurrencyFormat.format(item.value),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
