import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'stock_card_widget.dart';
import '../../domain/entities/stock_entity.dart';

class StockSkeletonWidget extends StatelessWidget {
  const StockSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStocks = List.generate(
      5,
      (index) => StockEntity(
        symbol: 'TATAMOTORS',
        name: 'Tata Motors Limited',
        price: 350.00,
        changePercent: '+1.25%',
        isSaved: false,
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: dummyStocks.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return StockCardWidget(
            stock: dummyStocks[index],
            onToggleSave: () {},
          );
        },
      ),
    );
  }
}
