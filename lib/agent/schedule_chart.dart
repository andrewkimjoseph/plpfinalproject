/// Dash pattern line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Example of a line chart rendered with dash patterns.
class DashPatternLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const DashPatternLineChart(this.seriesList,
      {super.key, required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory DashPatternLineChart.withSampleData(
    int maxYear,
    int totalAmount,
    int totalPrincipal,
    int totalInterest,
  ) {
    return DashPatternLineChart(
      _createSampleData(maxYear, totalAmount, totalPrincipal, totalInterest),
            animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        width: 400,
        child: charts.LineChart(seriesList, animate: animate));
  }

  /// Create three series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(
    int maxYear,
    int totalAmount,
    int totalPrincipal,
    int totalInterest,
  ) {
    final totalAmountData = [
      LinearSales(0, totalAmount),
      LinearSales(maxYear, 0),
    ];

    var totalPrincipalData = [
      LinearSales(0, 0),
      LinearSales(maxYear, totalPrincipal),
    ];

    var totalInterestData = [
      LinearSales(0, 0),
      LinearSales(maxYear, totalInterest),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Total Amount',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: totalAmountData,
      ),
      charts.Series<LinearSales, int>(
        id: 'Total Principal',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        // dashPattern: [2, 2],
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: totalPrincipalData,
      ),
      charts.Series<LinearSales, int>(
        id: 'Total Interest',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        // dashPattern: [8, 3, 2, 3],
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: totalInterestData,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}



// final List<charts.Series<dynamic, num>> seriesList;