import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StockDetailChartWidget extends StatelessWidget {
  final List<double> prices;
  final bool isNegative;

  const StockDetailChartWidget({
    super.key,
    required this.prices,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No chart data available',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final chartColor = isNegative
        ? AppColors.negativePrice
        : AppColors.positivePrice;
    final spots = prices
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minY: minPrice * 0.98,
          maxY: maxPrice * 1.02,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxPrice - minPrice) == 0
                ? 1
                : (maxPrice - minPrice) / 3,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.border.withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => AppColors.surface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: chartColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: chartColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return spot.x == (prices.length - 1).toDouble();
                },
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: chartColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    chartColor.withValues(alpha: 0.2),
                    chartColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
