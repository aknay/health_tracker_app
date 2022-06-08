import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:healthtracker/presentation/models/blood_glucose_models.dart';

class BloodGlucoseLineChart extends StatelessWidget {
  const BloodGlucoseLineChart({Key? key, required this.statistic}) : super(key: key);

  final BloodGlucoseStatistic statistic;

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_3,
      ];

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontSize: 12,
    );
    if (value.toInt() == statistic.minValue.toInt()) {
      return Text(value.toInt().toString(), textAlign: TextAlign.right, style: style);
    } else if (value.toInt() == statistic.maxValue.toInt()) {
      return Text(value.toInt().toString(), textAlign: TextAlign.right, style: style);
    } else if (value.toInt() == statistic.average.toInt()) {
      return Text(value.toInt().toString(), textAlign: TextAlign.right, style: style);
    }
    return const Text("");
  }

  SideTitles rightTitles() => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontSize: 12,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(statistic.getBottomLabel(value.toInt()), style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x4427b6fc),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) =>
            FlDotCirclePainter(radius: 3, color: Colors.blue.withOpacity(1)),
      ),
      belowBarData: BarAreaData(
        show: false,
        color: Colors.transparent,
        spotsLine: BarAreaSpotsLine(
          show: true,
          checkToShowSpotLine: (spot) {
            if (spot.x == 0 || spot.x == 6) {
              return false;
            }
            return true;
          },
          flLineStyle: FlLine(
            color: Colors.deepOrange,
            strokeWidth: 2,
          ),
        ),
      ),
      spots: statistic
          .getBloodGlucoseDayAverage()
          .map((e) => e.isEmptyReadings ? FlSpot.nullSpot : FlSpot(e.index.toDouble(), e.average))
          .toList());

  @override
  Widget build(BuildContext context) {
    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff75729e),
        fontSize: 12,
      );

      final meetAverage = value.toInt() == statistic.averageAsFixedPrecision.toInt();
      return meetAverage ? Text(AppLocalizations.of(context)!.average, style: style) : const Text("");
    }

    SideTitles leftTitles = SideTitles(
      getTitlesWidget: leftTitleWidgets,
      showTitles: true,
      interval: 1,
      reservedSize: 50,
    );

    FlTitlesData titlesData2 = FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: bottomTitles,
      ),
      rightTitles: AxisTitles(
        sideTitles: rightTitles(),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: leftTitles,
      ),
    );

    final sampleData2 = LineChartData(
      lineTouchData: lineTouchData2,
      gridData: gridData,
      titlesData: titlesData2,
      borderData: borderData,
      lineBarsData: lineBarsData2,
      minX: 0,
      maxX: statistic.maxIndex.toDouble(),
      maxY: statistic.maxValue.toInt() + 1,
      minY: statistic.minValue.toInt() - 1,
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(
          ///this is not right toInt but we cannot align the text and line for now
          y: statistic.average,
          color: Colors.green.withOpacity(0.8),
          strokeWidth: 2,
          dashArray: [10, 2],
        ),
      ]),
    );

    return LineChart(
      sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }
}
