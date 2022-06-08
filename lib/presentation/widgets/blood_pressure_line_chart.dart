import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthtracker/presentation/models/blood_pressure_model.dart';

class BloodPressureLineChart extends StatelessWidget {
  final BloodPressureReadingStatistic statistic;

  const BloodPressureLineChart({Key? key, required this.statistic}) : super(key: key);

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarDataDiastolic,
        lineChartBarDataSystolic,
      ];

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontSize: 12,
    );

    return value % 20 == 0 ? Text(value.toInt().toString(), textAlign: TextAlign.right, style: style) : const Text("");
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

  LineChartBarData get lineChartBarDataSystolic => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x442e27fc),
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
          .getBloodGlucoseDayAverage(true)
          .map((e) => e.isEmptyReadings ? FlSpot.nullSpot : FlSpot(e.index.toDouble(), e.average))
          .toList());

  LineChartBarData get lineChartBarDataDiastolic => LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: const Color(0x44ff2afb),
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
          .getBloodGlucoseDayAverage(false)
          .map((e) => e.isEmptyReadings ? FlSpot.nullSpot : FlSpot(e.index.toDouble(), e.average))
          .toList());

  Iterable<int> _positiveIntegers({required int start, required int end}) sync* {
    int i = start;
    while (i <= end) {
      yield i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = _positiveIntegers(start: statistic.minValue.toInt(), end: statistic.maxValue.toInt())
        .where((element) => element % 20 == 0) // don't use 0// take 10 numbers
        .toList(); // create a list

    SideTitles leftTitles = SideTitles(
      showTitles: false,
      interval: 20,
      reservedSize: 22,
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
        extraLinesData: ExtraLinesData(
            horizontalLines: _positiveIntegers(start: statistic.minValue.toInt(), end: statistic.maxValue.toInt())
                .where((element) => element % 20 == 0)
                .map((e) => HorizontalLine(
                      y: e.toDouble(),
                      color: Colors.grey.withOpacity(0.8),
                      strokeWidth: 0.5,
                      dashArray: [10, 2],
                    ))
                .toList()));

    return LineChart(
      sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }
}
