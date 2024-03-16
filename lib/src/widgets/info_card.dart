import 'package:finance/src/models/card_item.dart';
import 'package:finance/src/widgets/item_detail.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.list,
  });
  final List<CardItem> list;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: list
              .map(
                (e) => ItemDetail(
                  item: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
